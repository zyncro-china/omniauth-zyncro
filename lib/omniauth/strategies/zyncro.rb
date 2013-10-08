require 'omniauth-oauth'
require 'multi_json'

module OmniAuth
  module Strategies
    class Zyncro < OmniAuth::Strategies::OAuth
      option :name, 'zyncro'
      option :client_options, {
                     :authorize_path => '/tokenservice/jsps/login/login.jsp',
                     :request_token_path => '/tokenservice/oauth/v1/get_request_token',
                     :access_token_path => '/tokenservice/oauth/v1/get_access_token',
                     :site => 'https://my.sandbox.zyncro.com',
                     :proxy => ENV['http_proxy'] ? URI(ENV['http_proxy']) : nil}

      uid { access_token.params[:user_id] }

      info do
        {
          :name => raw_info['name'],
          :lastname => raw_info['lastName'],
          :email => raw_info['email']
          #:image => image_url(options),
          #:description => raw_info['description'],
          #:urls => {
          #  'Website' => raw_info['url'],
          #  'Zyncro' => "https://zyncro.com/#{raw_info['screen_name']}",
          #}
        }
      end

      extra do
        { :raw_info => raw_info }
      end

      def raw_info
        @raw_info ||= MultiJson.load(access_token.get('/api/v1/rest/users/profile').body)
      rescue ::Errno::ETIMEDOUT
        raise ::Timeout::Error
      end

      alias :old_request_phase :request_phase

      def request_phase
        force_login = session['omniauth.params'] ? session['omniauth.params']['force_login'] : nil
        screen_name = session['omniauth.params'] ? session['omniauth.params']['screen_name'] : nil
        x_auth_access_type = session['omniauth.params'] ? session['omniauth.params']['x_auth_access_type'] : nil
        if force_login && !force_login.empty?
          options[:authorize_params] ||= {}
          options[:authorize_params].merge!(:force_login => 'true')
        end
        if screen_name && !screen_name.empty?
          options[:authorize_params] ||= {}
          options[:authorize_params].merge!(:screen_name => screen_name)
        end
        if x_auth_access_type
          options[:request_params] ||= {}
          options[:request_params].merge!(:x_auth_access_type => x_auth_access_type)
        end

        if session['omniauth.params'] && session['omniauth.params']["use_authorize"] == "true"
          options.client_options.authorize_path = '/tokenservice/jsps/login/login.jsp'
        else
          options.client_options.authorize_path = '/tokenservice/jsps/login/login.jsp'
          #options[:authorize_params].merge!(:oauth_callback => 'http://zyncro.dev:9292/auth/zyncro/callback')
          options[:authorize_params].merge!(:oauth_callback => options[:oauth_callback])
        end

        old_request_phase
      end

      private

      def image_url(options)
        original_url = options[:secure_image_url] ? raw_info['profile_image_url_https'] : raw_info['profile_image_url']
        case options[:image_size]
        when 'mini'
          original_url.sub('normal', 'mini')
        when 'bigger'
          original_url.sub('normal', 'bigger')
        when 'original'
          original_url.sub('_normal', '')
        else
          original_url
        end
      end

    end
  end
end
