---
title: Overriding functions in Clojure
date: 2012-08-22
---
While testing in an OO language it is common to mock objects out of the
picture.  This could be do the fact that the object not yet implemented or
maybe it calls out to the third party service you rather not use when testing.

Clojure provides us some tools to do the same thing with functions we may want
to mock out.

### Dependency Injection

Like OO languages you can use dependency injection in a functional language like
Clojure. Lets say we have the following function.

{% highlight clojure %}
(defn do-work-son [arg]
  (third-party/big-function arg))
{% endhighlight %}

While testing we don't want to have to wait for the third parts big function to
run. We can re-write the function to take a second argument of what function to
run on the argument.

{% highlight clojure %}
(defn do-work-son [arg worker]
  (worker arg))
{% endhighlight %}

Now we can pass what ever we want to the function.  In production we call,

{% highlight clojure %}
(do-work-son "arg" third-party/big-function) 
{% endhighlight %}

While during the test we can do some thing like,

{% highlight clojure %}
(do-work-son "arg" #(* % 2))
{% endhighlight %}

Just to test that the function is being called.

### Redefinition

Sometimes Dependency Injection is just out of the question or would make your
code too complicated.  At these times we can redefine functions at run time
using `with-redefs`.  Here is the above example using this method.

{% highlight clojure %}
;; production code
(defn do-work-son [arg]
  (third-party/big-function arg))

;; test code
(with-redefs [third-part/big-function #(* % 2)]
  (do-work-son "arg"))
{% endhighlight %}
