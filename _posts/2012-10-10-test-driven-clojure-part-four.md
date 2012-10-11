---
layout: post
title: test driven Clojure part IV
---
In a series about tests we haven't been writing many of them.  Lets change
that.

### Writing the first test

Lets first start and build up our directory structure. And write a simple test.

{% highlight bash %}
$ mkdir -p src/katchie
$ mkdir -p spec/katchie
{%  endhighlight %}

{% highlight clojure %}
;; spec/katchie/core_spec.clj
(ns katchie.core-spec
  (:use [speclj.core]
        [joodo.spec-helpers.controller]
        [katchie.core]))

(describe "Katchie"

  (it "runs"
    (should true)))

(run-specs)
{% endhighlight %}

Running `lein spec` we should get the error

{% highlight text %}
java.io.FileNotFoundException: Could not locate katchie/core__init.class or katchie/core.clj on classpath
{% endhighlight %}

This is good.  Though a bit cryptic, it is telling us that it couldn't find the file
katchie/core.clj file.  Lets create it and see if that gets rid of the error.

{% highlight bash %}
$ touch src/katchie/core.clj
$ lein spec
{% endhighlight %}

Success!  We have a new error.

{% highlight text %}
java.lang.Exception: namespace 'katchie.core' not found after loading '/katchie/core'
{% endhighlight %}

Looks like we need to edit the file to include the katchie.core namespace.

{% highlight clojure %}
;; src/katchie/core.clj
(ns katchie.core)
{% endhighlight %}

Running `lein spec` another time and we have a passing spec!

{% highlight text %}
.

Finished in 0.00071 seconds
1 examples, 0 failures
{% endhighlight %}

You've successfully written a test for you application!  Congratulations.
