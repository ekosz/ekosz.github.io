---
layout: post
title: test driven Clojure part VI
---
Now we have a text displayed on our site, but its not very pretty.  To add some semantic
markup we're going to have to use HTML.  We'll be writing HTML in pure Clojure
code using a library called Hiccup.

### Introduction to Hiccup

Lets first create a layout file for our entire site.  This layout will be used
on every page.  Lets add it in a util folder.

{% highlight clojure %}
;; src/util/layout.hiccup
[:html 
  [:head
    [:title "Kachie - The Backpage of the Web!"]]
  [:body
    (eval (:template-body joodo.views/*view-context*))]]
{% endhighlight %}

The first thing you'll notice about the code above, is that its pure Clojure.
Unlike other HTML generating markup languages, Hiccup doesn't use any fancy
DSLs (Domain Specific Languages).  Every tag is represented by a vector, where
the first element in the tag is a keyword that acts as the name of the name.
Embedded tags are just embedded vectors.  If we want to give our tag a value,
like the title tag, we pass it as a string.

The `eval` line will insert the HTML that is specific to a certain page.

Lets try using this layout file in our homepage route.

{% highlight clojure %}
(with-mock-rendering :strict true :template-root "katchie")

(it "displays a homepage with HTML"
  (do-get "/")
  (should= "home" @rendered-template))
{% endhighlight %}

After using the helper method `with-mock-rendering` Joodo provides us with the
reference `@rendered-template` after we make a request to our application.  This
test should fail, telling us that @rendered-template is nil.  Lets fix that.

{% highlight clojure %}
(ns katchie.core
  (:require [joodo.views :refer [render-template]]))

(defn app-handler [request]
  {:status 200, 
   :headers {}, 
   :body (render-template "home" 
                          :layout "util/layout" 
                          :template-root "katchie")})
{% endhighlight %}

Lets use a new Joodo helper method, `render-template`.  Instead of us creating
the response hash from scratch, `render-template` will do that work for us.
The first argument is the template to load, and then many optional arguments.
The first of which is `:layout` and it points the layout file we want to
use.  Another optional argument is `:template-root`, which is where the root of
our template is located.  By default Joodo looks is src/views for the layout
file, but we're not going to architect our application like that.

Running the test now gives us a new error.

{% highlight text %}
Template Not Found: katchie/home.hiccup[.clj]
{% endhighlight %}

We need the create the template file its looking for.  Lets create a short
introduction to our app.

{% highlight clojure %}
;; src/katchie/home.hiccup
[:div {:class "headline"}
  [:h1 "Kachie"]
  [:h2 "Where dreams DO come true"]]
{% endhighlight %}

You'll notice I used a new technique in the hiccup file.  If you've done any HTML
development in the past, you know that HTML tags can have many arguments.
Arguments in Hiccup are passed as a hash-map as the second option of a tag
vector.

Now we have passing tests.  Booting up the server with `lein joodo server` and
viewing our application in our browser you should see...

{% highlight text %}
Kachie

Where dreams DO come true
{% endhighlight %}
