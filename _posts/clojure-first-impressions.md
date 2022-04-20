---
title: Clojure first impressions
date: 2012-07-23
---
First of all, a little background about my experience with Clojure before now.
Though I have never written in Clojure before, I have programmed functionally
using Erlang, and have written my own Lisp-like language. That gave me the
background needed so that Clojure shouldn't have been too much of a culture shock.

That being said, there was a lot of culture shock.  For the past 3 years I have
been a Ruby developer.  Though I have played around with many languages, at the
end of the day Ruby was what put bread on the table.  Clojure forced me to
think in a much different way than I was used to.

In OO languages one thinks in terms of Objects.  In functional languages one
thinks in terms of Functions.  While this may seem obvious, its important.  Data
is not longer coupled to behavior and all of the helper methods I had become
used to in Ruby were gone.  Enumerables like List and Vector had to be traversed 
manually. There is no each method anymore.

Probably the biggest difficulty I had with Clojure was not knowing its
Core API. There are two parts to every language; grammar and vocabulary. Grammar
is the syntax of the language, and vocab are its ideas in terms of words. For
most programmers, learning the grammar of a new language is the easy part.
Though languages looks different they all have the basics; variables, conditionals,
and methods.  Learning grammar is just acclimating to a languages flavor of these
basics.  Vocab on the other hand is hard.  Vocab, for the most part, has no
basics.  Every language is allowed to have as much or as little vocab as it
likes.  Some languages, like Ruby, have massive standard libraries that
encapsulate tons of ideas. Clojure on the other hand has a very tiny standard
library. Ideas in Clojure need to be expressed very precisely. Not knowing the 
vocab makes it very hard to program in.
