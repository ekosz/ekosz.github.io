---
layout: post
title: wear your rain coat
---
Applications normally have third party dependencies you don't control.  These
dependencies can show up as HTTP calls to foreign servers, third party libraries
(gems, jars, etc), or in a particularly large project maybe even calling into
a service written by another team.

Every time we use one of these third parties our own code becomes more tightly
coupled to the third party's interface.  What happens when we decide to update
our dependency and the interface has changed?  We have to go throughout our
entire application and change how we interact with that dependency at every
location.

We can protect ourselves from this scenario using a rain-coat.  A rain-coat
class wraps our dependencies.  At first it can act as a simple delegator,
keeping the same interface and transparently call through to the dependency.  
But, when the dependency's interface changes, it switches to be an adapter.  Our
rain-coat keeps the same interface, but modifies itself to keep working with
the new interface of the dependency.  And the rest of our application code is
none the wiser.
