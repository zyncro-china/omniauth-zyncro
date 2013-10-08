# OmniAuth Zyncro

This gem contains the Zyncro strategy for OmniAuth.

Zyncro offers a few different methods of integration. This strategy implements the browser variant of the "[Sign in with Zyncro](https://dev.zyncro.com/docs/auth/implementing-sign-zyncro)" flow.

Zyncro uses OAuth 1.0a. Zyncro's developer area contains ample documentation on how it implements this, so if you are really interested in the details, go check that out for more.

## Before You Begin

You should have already installed OmniAuth into your app; if not, read the [OmniAuth README](https://github.com/intridea/omniauth) to get started.

Now sign in into the [Zyncro developer area](http://dev.zyncro.com) and create an application. Take note of your Consumer Key and Consumer Secret (not the Access Token and Secret) because that is what your web application will use to authenticate against the Zyncro API. Make sure to set a callback URL or else you may get authentication errors. (It doesn't matter what it is, just that it is set.)

## Using This Strategy

First start by adding this gem to your Gemfile:

```ruby
gem 'omniauth-zyncro'
```

If you need to use the latest HEAD version, you can do so with:

```ruby
gem 'omniauth-zyncro', :github => 'arunagw/omniauth-zyncro'
```

Next, tell OmniAuth about this provider. For a Rails app, your `config/initializers/omniauth.rb` file should look like this:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :zyncro, "CONSUMER_KEY", "CONSUMER_SECRET" {
    :oauth_callback => 'http://zyncro.dev:9292/auth/zyncro/callback'  
  }
end
```

Replace CONSUMER_KEY and CONSUMER_SECRET with the appropriate values you obtained from dev.zyncro.com earlier.

## Authentication Options

Zyncro supports a [few options](https://dev.zyncro.com/docs/api/1/get/oauth/authenticate) when authenticating. Usually you would specify these options as query parameters to the Zyncro API authentication url (`https://api.zyncro.com/oauth/authenticate` by default). With OmniAuth, of course, you use `http://yourapp.com/auth/zyncro` instead. Because of this, this OmniAuth provider will pick up the query parameters you pass to the `/auth/zyncro` URL and re-use them when making the call to the Zyncro API.

The options are:

* **force_login** - This option sends the user to a sign-in screen to enter their Zyncro credentials, even if they are already signed in. This is handy when your application supports multiple Zyncro accounts and you want to ensure the correct user is signed in. *Example:* `http://yoursite.com/auth/zyncro?force_login=true`

* **screen_name** - This option implies **force_login**, except the screen name field is pre-filled with a particular value. *Example:* `http://yoursite.com/auth/zyncro?screen_name=jim`

* **secure_image_url** - Set to `true` to use https for the user's image url. Default is `false`.

* **image_size**: This option defines the size of the user's image. Valid options include `mini` (24x24), `normal` (48x48), `bigger` (73x73) and `original` (the size of the image originally uploaded). Default is `normal`.

* **x_auth_access_type** - This option (described [here](https://dev.zyncro.com/docs/api/1/post/oauth/request_token)) lets you request the level of access that your app will have to the Zyncro account in question. *Example:* `http://yoursite.com/auth/zyncro?x_auth_access_type=read`

* **use_authorize** - There are actually two URLs you can use against the Zyncro API. As mentioned, the default is `https://api.zyncro.com/oauth/authenticate`, but you also have `https://api.zyncro.com/oauth/authorize`. Passing this option as `true` will use the second URL rather than the first. What's the difference? As described [here](https://dev.zyncro.com/docs/api/1/get/oauth/authenticate), with `authenticate`, if your user has already granted permission to your application, Zyncro will redirect straight back to your application, whereas `authorize` forces the user to go through the "grant permission" screen again. For certain use cases this may be necessary. *Example:* `http://yoursite.com/auth/zyncro?use_authorize=true`. *Note:* You must have "Allow this application to be used to Sign in with Zyncro" checked in [your application's settings](https://dev.zyncro.com/apps) - without it your user will be asked to authorize your application each time they log in.

## Authentication Hash
An example auth hash available in `request.env['omniauth.auth']`:

```ruby
{
  :provider => "zyncro",
  :uid => "123456",
  :info => {
    :nickname => "johnqpublic",
    :name => "John Q Public",
    :location => "Anytown, USA",
    :image => "http://si0.twimg.com/sticky/default_profile_images/default_profile_2_normal.png",
    :description => "a very normal guy.",
    :urls => {
      :Website => nil,
      :Zyncro => "https://zyncro.com/johnqpublic"
    }
  },
  :credentials => {
    :token => "a1b2c3d4...", # The OAuth 2.0 access token
    :secret => "abcdef1234"
  },
  :extra => {
    :access_token => "", # An OAuth::AccessToken object
    :raw_info => {
      :name => "John Q Public",
      :listed_count" => 0,
      :profile_sidebar_border_color" => "181A1E",
      :url => nil,
      :lang => "en",
      :statuses_count => 129,
      :profile_image_url => "http://si0.twimg.com/sticky/default_profile_images/default_profile_2_normal.png",
      :profile_background_image_url_https => "https://twimg0-a.akamaihd.net/profile_background_images/229171796/pattern_036.gif",
      :location => "Anytown, USA",
      :time_zone => "Chicago",
      :follow_request_sent => false,
      :id => 123456,
      :profile_background_tile => true,
      :profile_sidebar_fill_color => "666666",
      :followers_count => 1,
      :default_profile_image => false,
      :screen_name => "",
      :following => false,
      :utc_offset => -3600,
      :verified => false,
      :favourites_count => 0,
      :profile_background_color => "1A1B1F",
      :is_translator => false,
      :friends_count => 1,
      :notifications => false,
      :geo_enabled => true,
      :profile_background_image_url => "http://twimg0-a.akamaihd.net/profile_background_images/229171796/pattern_036.gif",
      :protected => false,
      :description => "a very normal guy.",
      :profile_link_color => "2FC2EF",
      :created_at => "Thu Jul 4 00:00:00 +0000 2013",
      :id_str => "123456",
      :profile_image_url_https => "https://si0.twimg.com/sticky/default_profile_images/default_profile_2_normal.png",
      :default_profile => false,
      :profile_use_background_image => false,
      :entities => {
        :description => {
          :urls => []
        }
      },
      :profile_text_color => "666666",
      :contributors_enabled => false
    }
  }
}
```

## Watch the RailsCast

Ryan Bates has put together an excellent RailsCast on OmniAuth:

[![RailsCast #241](http://railscasts.com/static/episodes/stills/241-simple-omniauth-revised.png "RailsCast #241 - Simple OmniAuth (revised)")](http://railscasts.com/episodes/241-simple-omniauth-revised)

## Supported Rubies

OmniAuth Zyncro is tested under 1.8.7, 1.9.2, 1.9.3 and Ruby Enterprise Edition.

[![CI Build
Status](https://secure.travis-ci.org/arunagw/omniauth-zyncro.png)](http://travis-ci.org/arunagw/omniauth-zyncro)

## Note on Patches/Pull Requests

- Fork the project.
- Make your feature addition or bug fix.
- Add tests for it. This is important so I don’t break it in a future version unintentionally.
- Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
- Send me a pull request. Bonus points for topic branches.

## License

Copyright (c) 2011 by Arun Agrawal

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
