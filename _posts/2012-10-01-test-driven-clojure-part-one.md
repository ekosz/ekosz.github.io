---
layout: post
title: test driven Clojure part I
---
Welcome to my new series Test Driven Clojure.  In these series of blog posts
we'll use a collection of open source tools and best testing practices to
create a social news aggregation site from scratch. 

### Tools

The tools we'll be using for this project are all free and open source.  After
completing this series feel free to go back and swap out some of these tools
for others that do the same job.

[Leiningen](https://github.com/technomancy/leiningen): At the time of this
writing Leiningen has become the de facto tool for managing dependencies in
Clojure.  After an initial setup, Leiningen makes easy work of downloading
external libraries and installing them.

[Joodo](https://github.com/slagyr/joodo): Joodo is a lightweight web framework built 
off of another popular Clojure project Ring.  Joodo uses Ring's Router and
provides us an simple API for creating complex web applications. Joodo will
handle all of the HTTP communication for us, letting us focus on the behavior of
our application.

[Hyperion](https://github.com/8thlight/hyperion): Our application will
eventually need to store data between requests, or it wouldn't make for a very
good website.  So how are we going to save our data?  A SQL database? A NoSQL DB?
There are too many choices of datastores in the wild currently. As responsible
engineers, we're not going to make such an important choice about our
application until we know more about our requirements.  Hyperion lets us stay
agile and flexible our development process.  Hyperion provides a single API
that can then be hooked into many concrete databases later. Using Hyperion we
can nearly wait until the project is completed before we're forced to pick
a data saving scheme.

[Hiccup](https://github.com/weavejester/hiccup): Recently there has been
a trend in web applications to move to fat javascript heavy web apps.  Views
are rendered client side and simple JSON data is piped in from the server.
That is NOT what we're going to be doing.  We will be rendering our views
server side in Hiccup.  Hiccup follows the Clojure idiom of using data as code
and provides a clean way of generating HTML.

[Speclj](https://github.com/slagyr/speclj): This wouldn't be a very good series
on testing if we didn't have a tool for writing good tests.  Speclj provides
Clojure developers with a Rspec-esk API for writing BDD style tests.
