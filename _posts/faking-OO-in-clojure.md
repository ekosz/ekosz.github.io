---
title: Faking OO in Clojure
date: 2012-09-13
---
When programming in a functional language, the often comes a time when we must
couple data to functions like in an Object Oriented language.  I mostly see
this happen in terms of databases and relations.

In my hypothetical application I have users that have many documents.  Here's
what their [Hyperion](https://github.com/8thlight/hyperion) protocols might look like.

{% highlight clojure %}
(ns sample.user.user
  (:require [hyperion.api :refer [defentity]]))

(defentity User
  [name])
{% endhighlight %}

{% highlight clojure %}
(ns sample.document.document
  (:require [hyperion.api :refer [defentity]]))

(defentity Document
  [name]
  [body]
  [user-key :type :key])
{% endhighlight %}

What if we wanted to add a method for users to get their corresponding
documents? Follow certain conventions we can create a method that looks very OO.

{% highlight clojure %}
(ns sample.user.user
  (:require [hyperion.api :refer [defentity find-by-kind]]))

;defentity

(defn documents [this]
  (find-by-kind "document" :filters [:= :user-key (:key this)]))
{% endhighlight %}

By using `this` as the name of the argument we are but into the mindset of
manipulating User hashes.  Every function defined inside this namespace should
take a user hash as the first argument.
