---
title: Writing Joodo middleware
date: 2012-09-04
---
While working on a [Joodo](http://www.joodoweb.com/) project, I came across the issue of authentication.
On a controller by controller basis, we had to redirect users away if they
weren't authenticated.

In Rails the standard way to handle this use case, is to use a before filter,
where the method is defined in the application controller.  Joodo doesn't have
before filters, but what it does have is middleware.

Joodo middleware takes a handler and returns a function that takes a request
and does something with it.  It can modify the request and pass it on to the
next handler, or completely blow the stack and never call the next handler.

Heres the code I ended up writing as a authentication middleware.

```clojure
(ns sample.middleware.authentication
  (:require [ring.util.response :refer [redirect]]
            [sample.athentication :refer [is-valid-user]]))

(defn with-valid-user [handler]
  (fn [request]
    (if (is-valid-user request)
      (handler request) ; pass on request to next middleware
      (redirect "/authentication"))))
```

Now I can use this middleware in my controllers.

```clojure
(ns sample.user.user-controller
  (:require [compojure.core :refer :all ]
            [sample.middleware.authentication :refer [with-valid-user]]))

(defroutes user-controller
  (with-valid-user
    (context "/user" []
      (POST "/" [] (create-user))
      (GET "/new" [] (new-user)))))
```
