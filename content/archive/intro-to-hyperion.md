---
title: Introduction to Hyperion
date: 2012-08-27
---

[Hyperion](https://github.com/8thlight/hyperion) is a common datastore API for
Clojure. It wraps various databases in a common API and lets developers hold
off the choosing of a DB.

First off add Hyperion to your project.clj file.

```clojure
(defproject sample "0.0.1"
  :dependencies [[hyperion/core "1.0.0"]])
```

Next we can write a spec to test out the functionality of Hyperion. We'll be
using [Speclj](http://speclj.com/) for the specs.

```clojure
(ns sample.core-spec
  (:require
    [speclj.core :refer :all]
    [sample.core :refer :all]
    [hyperion.core :refer :all]
    [hyperion.memory :refer [new-memory-datastore]]))

(describe "Hyperion"
          (it "can store a value"
            (save {:kind "test" :name "Eric"})
            (should= "Eric" ((comp :name first find-by-kind) "test"))))
```

This is what the Hyperion API looks like. The `save` function takes a hash-map
or record, and saves it to the datastore. Each hash-map should have a type,
this will be the collection the record is associated with. We then can use
lookup APIs like `find-by-kind`. This method saves a kind and returns a vector
of hash-maps that correspond to that type.

Running this spec we get the error.

    No Datastore bound (hyperion/*ds*) or installed (hyperion/DS).

We can fix this by setting the DB to be a in-memory database in our core.clj
file.

```clojure
(ns sample.core
  (:require
    [hyperion.core :refer [DS]]
    [hyperion.memory :refer [new-memory-datastore]]))

(reset! DS (new-memory-datastore))
```

Now we have passing tests!

We can add another test to make sure the database resets between tests.

```clojure
(it "has a new database each test"
  (save {:kind "test" :name "Alex"})
  (should= 1 (count (find-by-kind "test"))))
```

This should fail in conjunction with the other test. We can fix it by wrapping
our tests in a new-memory-datastore.

```clojure
(describe "Hyperion"
          (around [it]
                  (binding [*ds* (new-memory-datastore)]
                    (it)))
```

This binds a new-memory-datastore for each test. Specs should now be passing.

The rest of the Hyperion API can be found on its [Github page](https://github.com/8thlight/hyperion).
As of this writing Hyperion currently supports Google App Engine, MySQL,
Postgres, Sqlite, Riak, and MongoDB. Using Hyperion the choosing a database
can happen far down the development pipeline as well switching out the DB is as
simple as changing a line of code.
