---
title: Test driven Clojure part IV
date: 2012-10-10
---
In a series about tests we haven't been writing many of them.  Lets change
that.

### Writing the first test

Lets first start and build up our directory structure. And write a simple test.

```bash
$ mkdir -p src/katchie
$ mkdir -p spec/katchie
```

```clojure
;; spec/katchie/core_spec.clj
(ns katchie.core-spec
  (:use [speclj.core]
        [joodo.spec-helpers.controller]
        [katchie.core]))

(describe "Katchie"

  (it "runs"
    (should true)))

(run-specs)
```

Running `lein spec` we should get the error

```text
java.io.FileNotFoundException: Could not locate katchie/core__init.class or katchie/core.clj on classpath
```

This is good.  Though a bit cryptic, it is telling us that it couldn't find the file
katchie/core.clj file.  Lets create it and see if that gets rid of the error.

```bash
$ touch src/katchie/core.clj
$ lein spec
```

Success!  We have a new error.

```text
java.lang.Exception: namespace 'katchie.core' not found after loading '/katchie/core'
```

Looks like we need to edit the file to include the katchie.core namespace.

```clojure
;; src/katchie/core.clj
(ns katchie.core)
```

Running `lein spec` another time and we have a passing spec!

```text
.

Finished in 0.00071 seconds
1 examples, 0 failures
```

You've successfully written a test for you application!  Congratulations.
