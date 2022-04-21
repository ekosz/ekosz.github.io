---
title: Test driven clojure part V
date: 2012-10-11
---
We now have passing tests, but our website isn't very functional.  Lets add
a home page for our (soon to be) millions of visitors.

### Writing our first Joodo-based test

Lets write a test that makes sure that we get a 200 response back from the
server when we acsess the root path.

```clojure
(it "displays a homepage"
  (let [response (do-get "/")]
    (should= 200 (:status response))))
```

`do-get` is a method given to us by the joodo.spec-helper.controller namespace.
It sends an imaginary post to the path, and seconds the result.  The result is
a hash-map of `{:status ..., :headers ..., :body ...}`.

Running this test, we get our next error.  Yay!

```text
.F

Failures:

  1) Katchie displays a homepage
     Attempting to call unbound fn: #'joodo.spec-helpers.controller/*routes*
```

What does this mean?  Its our most un-helpful message yet.  The problem is that
the `do-get` method doesn't know what Joodo controller to test.  The joodo
spec-helpers gives us a message that will point our tests to the right
location.

```clojure
(with-routes app-handler)
```

Adding that line to our tests will tell Joodo to use the app-handler.
Unfortunately we haven't built a app handler yet and we get another error.

```text
java.lang.RuntimeException: Unable to resolve symbol: app-handler in this context
```

Lets create that handler in our core.clj file.

```clojure
(ns katchie.core)

(def app-handler)
```

Running again we get another error.  Remember whenever the message we get back
changes, we're making progress.

```text
Attempting to call unbound fn: #'katchie.core/app-handler
```

Looks like app-hander is meant to be a function. Lets change the definition of
app-hander to reflect that.

```clojure
(ns katchie.core)

(defn app-handler [])
```

`lein spec` gives us our next error.

```text
Wrong number of args (1) passed to: core$app-handler
```

Great!  Now we know that our app-handler has to take an argument.  We don't
know what that argument is yet, but we're slowly learning about Joodo and how
it works. Lets rewrite our app-hander method to take that argument then print
it out to the console.

```clojure
(ns katchie.core)

(defn app-handler [thing]
  (println thing))
```

```text
$ lein spec
.{:request-method :get, :uri /}
F

Failures:

  1) Katchie displays a homepage
     Expected: <200>
          got: nil (using =)
```

We've now discovered the last two pieces of information we need to realize
how Joodo works.  The first is obvious, the argument we receive is the request
hash-map.  Is has a :request-method key and a :uri key.  The second piece of
information we've gathered is more hidden.  Joodo expects this method to return
a response hash.  The test is currently calling (:status nil) which returns
nil.

One more rewrite of our core.clj file is all we need to get this test to pass.

```clojure
(ns katchie.core)

(defn app-handler [request]
  {:status 200, :headers {}, :body "Hello World!"})
```

```text
..

Finished in 0.00065 seconds
2 examples, 0 failures
```

Perfect we've gotten our test to pass and written just enough code to have
a fully working Joodo application.  We can test it out by running `lein joodo
server`.

After that command you can direct your browser to localhost:8080 and see the
fruit of your labor.

```text
HTTP ERROR 500

Problem accessing /. Reason:

    java.lang.RuntimeException: java.io.FileNotFoundException: config/environment.clj (No such file or directory)
```

Well thats not good.  Looks like Joodo was expecting a config/environment.clj
file to exist. Lets create that quickly.

```clojure
;; config/environment.clj
(alter-env! assoc
  :joodo.root.namespace "katchie.core")
```

This tells Joodo that its root name space is that core file we just created.

```text
HTTP ERROR 500

Problem accessing /. Reason:

    java.lang.RuntimeException: java.io.FileNotFoundException: config/development.clj (No such file or directory)
```

Well another file missing.  Lets create that too.

```clojure
(alter-env! assoc
  :joodo-env "development"
  :hostname "localhost:8080")
```

This file sets some global configuration for our development environment. One
last time into the breach.  Lets start our server and see what we get.

```text
Hello world!
```

You did it!  Congratulations on creating your first Joodo application.
