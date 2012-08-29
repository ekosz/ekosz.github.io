---
layout: post
title: saving parentheses using comp
---
When I started programming in Clojure I was immediately turned off my all of the
parentheses that littered the source code.  Over time you get used to them, but
its still always nice when you can reduce the amount that you have to use.

Thats why `comp` is such an awesome tool in any function language.  `comp` takes
a series of functions and combines them into one big function. Its easier to
see than it is to explain.

{% highlight clojure%}
; The old way
(:name (last (:fields (first (find-by-type "topic")))))
; The new hotness with comp
((comp :name last :fields first find-by-type) "topic")
{% endhighlight %}

Each function passed to `comp` will be called in sequence.  This saves on
parentheses and complexity.
