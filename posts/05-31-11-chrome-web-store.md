Creating a Google Chrome Web Store App
--------------------

Last week I launched [Japanese Vocab Tutor](https://chrome.google.com/webstore/detail/ldemblkooloonmjfiainhkhmmlelfnfb) mostly to be able to say I published an app.  The actual application took about two days to create and style, and is a pretty basic flash card application with some nice features.  The real problem happened on the third day, hooking it up to the Google Licence API.  This was a lot harder then I thought it would be.

I used three tools to pull it off:

1. [Sinatra](http://www.sinatrarb.com/) - For running the show
2. [Rack OpenID](https://github.com/josh/rack-openid) - To grab the users Google OpenID ID (confusing I know)
3. [Signet Oauth Client](http://signet.rubyforge.org/) - To access the Google Licence API

First require all of it

    require 'rubygems'
    require 'sinatra'
    require 'json'
    require 'signet/oauth_1/client'
    require 'rack/openid'

    use Rack::Session::Cookie
    enable :sessions
    use Rack::OpenID

Now for the fun stuff

    get '/login' do
        # Have provider identifier, tell rack-openid to start OpenID process
        headers 'WWW-Authenticate' => Rack::OpenID.build_header(
          :identifier => "https://www.google.com/accounts/o8/id",
          :required => ["http://specs.openid.net/auth/2.0/identifier_select"],
          :realm => "<YOURSITEHERE>",
          :return_to => url_for('/openid/complete'),
          :method => 'post')
        halt 401, 'Authentication required.'
    end

    get '/logout' do
      session.clear
      redirect '/'
    end

    # Handle the response from the OpenID provider
    post '/openid/complete' do
      resp = request.env["rack.openid.response"]
      if resp.status == :success
        client = Signet::OAuth1::Client.new(
          :client_credential_key => consumer_key,
          :client_credential_secret => consumer_secret,
          :token_credential_key => oauth_token,
          :token_credential_secret => oauth_token_secret
        )
        openid_uri = Signet::OAuth1.encode(resp.identity_url)
        request_uri =  'https://www.googleapis.com/chromewebstore/v1/licenses/'+
                        app_id+'/'+openid_uri
        response = client.fetch_protected_resource( :uri => request_uri )

        status, headers, body = response

        session[:bought] = JSON.load(body[0])['accessLevel'] || 'NONE'
        
        redirect '/'
      else
        "Error: #{resp.status}"
      end
    end

###Login

First off, your `/login` is where you send your users when you need to find 
their payment status.  I have all of my users do this right from the start.
This method creates a page with a status code of `401` and a special header of
`WWW-Authenticate`.  When `Rack OpenID` sees this status code and the this
header, it automatically redirects to the proper OpenID provider, and provides the
information needed.

You provide the header with a hash consisting of:

1. `:identifier` - What OpenID provider to use, in this case we need Google.
2. `:required` - An array of urls that correlates to what parameters of the user
   you want the OpenID provider to give you.  In this case all we want in the
   users Google OpenID ID.  Google provides [this page](http://code.google.com/apis/accounts/docs/OpenID.html) for matching parameters to urls.
3. `:realm` - This is the website that you are asking users to trust, it should
   be the exact same website that they are being returned to. The web store
   will make sure that this is the same url that your application is located.
4. `:return_to` - Where to redirect the user after they sign in.  I use
   a helper method to generate the full url.
5. `:method` - How the user should be redirected back to your site, we want
   post in this case.

###Callback

Next we have the `post /openid/complete` pattern to fill out.  This is where
the user is redirected after they sign in through OpenID.  `Rack OpenID` makes
another appearance as it automatically recognizes OpenID responses, and stuffs the
data into an Environment Variable called `rack.openid.response`.  You grab that
data, and check if the response is successful.  If so, its time for some Oauth
magic.

Things you will need for this part:

1. Consumer Key and Consumer Secret - For all Web Store Oauth requests, these
   will both be "anonymous".
2. Token Key and Token Secret - These can be generated at the Web Store
   developer dashboard.  [More Info Here](http://code.google.com/chrome/webstore/docs/check_for_payment.html#token).
3. App ID - This can be found in the url of your Web Store application.

After generating the Oauth client object, you must encode the Google OpenID ID,
found the response's `identity_url`, into something that Oauth can accept.
Next you construct the Oauth `request url`, which is one part the Google Licence
API url, one part `app id`, and one part encoded `identity_url`.  Finally you
can send that off, and get your Oauth response.

The response is made of three parts, `[status, headers, body]`. To make your
application more robust you can do some error checking here, but for me
I skipped right into the heart of the matter, which was the body.  The body is
an array, with a JSON encoded response as the first element. This final
response has a property of `accessLevel`, which according [to their
documentation](http://code.google.com/chrome/webstore/docs/check_for_payment.html#response)
will either be `FULL`, `FREE_TRIAL`, or `NONE`.  This is where I had my biggest
issue, their documentation is WRONG, in the worst way.  If a user has not
purchased a copy, or installed a free trail, the `accessLevel` will not be
`NONE`, it just won't exist.  I currently set a session variable with this data,
but you can do anything you want with it.

And thats it. This took me about a day and a half, just to hunt through all of
the documentation, but now you don't have to!
