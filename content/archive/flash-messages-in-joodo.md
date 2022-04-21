---
title: Flash messages in Joodo
date: 2012-09-11
---
[Joodo](http://www.joodoweb.com/) has built in support for Rails-like flash messages.  
These are great for persisting one-time messages between requests.

First off we need to set the message in the controller.

```clojure
(defn- create-user []
  (let [params (:params *request*)]
    (save (hash-map :kind "user" :name (:name params)))
    (assoc
      (redirect-after-post "/")
      :flash {:messages ["User Created!"]})))
```

Now we can grab this flash message from our view.

```clojure
(if-let [flash (:flash *request*)]
  [:div {:class "flash"}
    (if-let [messages (:messages flash)]
      [:div {:class "messages"}
        (map #(identity [:div {:class "message"} %]) messages)])])
```
