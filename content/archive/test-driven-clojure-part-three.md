---
title: Test driven Clojure part III
date: 2012-10-03
---
Now that we have Leiningen installed we can start installing the rest of our
Clojure toolkit and writing some code.

### Creating the project.clj

We've come to our first major hurdle, what are we going to name this
application?  It needs to be catchy, easy to remember, and have great SEO
potential.  Lets go with "Katchie"!  I can already start to see the money
flowing in.

In your normal coding directory, lets create a folder where all of our code is
going to live.

```bash
$ cd ~/Code
$ mkdir katchie
$ cd katchie
```

Following proper coding habits we're going to create a project.clj.  The 
project.clj stores the meta-information about a Clojure application.  Here is
where we'll list our external dependencies and configure our setup.

```clojure
(defproject katchie "0.0.1"
  :description "A socail news aggregator"
  :dependencies [[org.clojure/clojure "1.4.0"]
                 [joodo "0.11.0"]
                 [hyperion "3.3.0"]]
  :profiles {:dev {:dependencies [[speclj "2.3.1"]]}}
  :plugins [[speclj "2.3.1"]
            [joodo/lein-joodo "0.11.0"]]
  :test-paths ["spec/"]
  :java-source-paths ["src/"])
```

This might look complceted at first but lets break it down line by line.

```clojure
(defproject katchie "0.0.1"
```

At the top level of our project.clj we call this special method defproject.
The first argument is what we want to call the namespace of the project, and
the second is a string representation of the version.  We're going to use
"0.0.1" for now, until we add some features.  But the end of this series we
should be at our "1.0.0" release.

```clojure
:description "A social news aggregator"
```

This is not very important to us, but if we were creating a tool for other
developers to use, this would be the description they would see in leiningen
next to the name of our project.

```clojure
:dependencies [[org.clojure/clojure "1.4.0"]
               [joodo "0.11.0"]
               [hyperion "3.3.0"]]
```

These are the current dependencies of our project.  We'll be using Clojure
version "1.4.0", Joodo "0.11.0", and Hyperion "3.3.0".  These might not be the
current versions of these projects, but thats what we'll use during the
development of this project. After completing this series I'll leave it as
a task to you to update these libraries to their most recent versions then
update the project to work the updated APIs.

```clojure
:profiles {:dev {:dependencies [[speclj "2.3.1"]]}}
```

We have another dependency, and that our testing framework Speclj.  We treat
Speclj differently, because its a development dependency.  We won't need Speclj
on our production server.

```clojure
:plugins [[speclj "2.3.1"]
          [joodo/lein-joodo "0.11.0"]]
```

These lines add the Speclj and Joodo plugins to the Leiningen.  Command line
interface.  We'll be using their commands later in the series.

```clojure
:test-paths ["spec/"]
:java-source-paths ["src/"])
```

These last lines help point our dependencies to the right locations.

That's it for now.  Running `lein deps` should spew out a bunch of output as it
installs our dependencies.  If this is the first time your installing Clojure,
this might take a while.
