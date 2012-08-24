---
layout: post
title: Google oauth in Clojure
---
Recently in my Clojure project we had to integrate with Google's OAuth for
authenticating our users.  It was a pretty painful process, so here's a quick
guide for anyone that wants to do this in the future.

For this guide I will be using `stuarth/clj-oauth2 "0.3.2"`.  First add that as
a dependency to your project.clj file.  Next lets create a authentication
module.

    (ns authentication
      (:require
        [cheshire.core :refer [parse-string]
        [clj-oauth2.client :as oauth2]))

    (def login-uri
      "https://accounts.google.com")

    (def google-com-oauth2
      {:authorization-uri (str login-uri "/o/oauth2/auth")
       :access-token-uri (str login-uri "/o/oauth2/token")
       :redirect-uri "http://localhost:8080/authentication/callback"
       :client-id "CLIENT"
       :client-secret "CLIENT-SECRET"
       :access-query-param :access_token
       :scope ["https://www.googleapis.com/auth/userinfo.email"]
       :grant-type "authorization_code"
       :access-type "online"
       :approval_prompt ""})
    
    (def auth-req
      (oauth2/make-auth-request google-com-oauth2))

    (defn- google-access-token [request]
      (oauth2/get-access-token google-com-oauth2 (:params request) auth-req))

    (defn- google-user-email [access-token]
      (let [response (oauth2/get "https://www.googleapis.com/oauth2/v1/userinfo" {:oauth access-token})]
        (get (parse-string (:body response)) "email")))

    ;; Redirect them to (:uri auth-req)

    ;; When they comeback to /authentication/callback
    (google-user-email  ;=> user's email trying to lgo in
      (google-access-token *request*))

So what did we do here?  First of all we required the OAuth2 dependency into
our namespace. We also included cheshire, Clojure's JSON parsing library. Then we 
created a hash `google-com-oauth2`.  This hash contains all of the information Google
needs when we request a OAuth2 access token. Replace the :client-id and
:client-secret with the values you get from Google when you set up your Google
application. Also be sure that your :redirect-uri matches the one you supplied
Google.  

Using this data has we can construct a auth-req using our OAuth2 library.  When
users go to our application, when they try and log on the app should redirect
them to `(:uri authentication/auth-req)`.

When the user gets back to our application it will be at out callback uri.
The request params of this request should look like,

    {:code "4/dasfjkhadsfkalsdasdfaskjf}

Using this request object we can get back a access-token from Google.  Finally
once we have an access token, we get start making oauth/get's to retrieve user
info from Google.  I've written the method google-user-email, but you can get
other values from the user if you change the scope of your request.


