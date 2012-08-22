---
layout: post
title: screaming architecture
---
When you look rails application you are greeted with a familiar
directory structure.  Are given an app/ directory with the folders model/,
view/, controller/.  At the time of Rails inception this was considered a big
win in terms of convention over configuration.  This forced developers to think
in terms of MVC and develop cleaner code.  But over time developers realized
that this wasn't the ideal way to organize code.

What can we learn about an application from a rails directory?  We know its
MVC, but thats about it.  We don't know what the application does or any of its
intent.  What if it looked something like this?

    app/
      user/
      bank_account/
      transfer/

We instantly know this is a banking application that has users and transfers.
That is the purpose of scream architecture.  Inside each of those folders we
would include the models, views, and controllers for that component.

    app/
      user/
        user.rb
        user_controller.rb
        new.html.haml
      bank_account/
        bank_account.rb
        bank_account_controller.rb
      ...

All of the information we need about a component is located in one location.

So lets set up Joodo to allow this type of configuration.  Joodo with a standard 
MVC layout, that we'll have to change.

Lets edit the core.clj file.

    (defroutes !-APP_NAME-!-routes
      (GET "/" [] (render-template "index"))
        (controller-router '!-APP_NAME-!.controller)
          (not-found (render-template "not_found" :template-root
          "!-DIR_NAME-!/view" :ns `!-APP_NAME-!.view.view-helpers)))

    (def app-handler
      (->
        !-APP_NAME-!-routes
          (wrap-view-context :template-root "!-DIR_NAME-!/view" :ns
          `!-APP_NAME-!.view.view-helpers)))

The important lines here are the controller-router and wrap-view-context. These 
lines set Joodo looking the controller/ directory for controllers and view/
directory for views.  Lets change those lines to be a little more free form.


    (defroutes !-APP_NAME-!-routes
      (GET "/" [] (render-template "view/index"))
        (controller-router '!-APP_NAME-!)
          (not-found (render-template "view/not_found" 
                                      :template-root "!-DIR_NAME-!" 
                                      :layout "view/layout" 
                                      :ns `!-APP_NAME-!.view.view-helpers)))

    (def app-handler
      (->
        !-APP_NAME-!-routes
          (wrap-view-context :template-root "!-DIR_NAME-!" 
                             :layout "view/layout" 
                             :ns `!-APP_NAME-!.view.view-helpers)))

Here we changed the view-context to point to the app directory and the
controller-router to also point to the route directory.  Because of these
changes we had to make a couple others to keep the application working the same
as it was.  First off, a :layout option had to be added, as the layout file
will no longer be located where the views are stored.  Also, global view files
must be explicitly told to be located in the view/ directory.

Finally we can change up the directory structure.  All of the models, views,
and controllers can be put in there own shared folders inside the app
directory. Then the controller/ and model/ folders can be removed.  The view/
directory will now only store global views.
