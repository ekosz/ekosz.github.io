---
title: "OTP: Gen Server part II"
date: 2012-08-06
---
In my last post I introduced the concept of OTP and gen\_server.  This post
I hope to dive deeper into gen\_server.

We've already seen the handle\_cast callback method, but there are many other
callbacks in gen\_server. Lets take a look at a couple.

### handle\_call(method, state)

handle\_call is much like handle\_cast as it in charge of updating the state of
the server, but it is used for asynchronous updates.  

handle\_cast normally responds `{:reply, result, new_state}`, but handle\_call
normally responds `{:noreply, new_state}`.  handle\_call should be used
whenever the method doesn't need to know who is calling it, as well as doesn't
need to return anything to its caller.

### handle\_info(message, state)

handle\_info responds the same as handle\_call, but it gets called when random
messages are sent to the server through the `<-` operator. Normally this
doesn't update the state of the server, but that is up to the developer.

### terminate(reason, state)

The terminate method is called when the server is shutting down.  This could
because of an error, one of the other methods told the server to shutdown, or
its parent is shutting down.  The callback is only in charge of cleanup and doesn't
return anything.

### code\_change(old, state, extra)

The code\_change callback is called when the servers code is being updated.
The old parameter is a version number.  This method makes sure that the state
is in a position where is can handle the code change.  Don't worry about the
extra parameter here it isn't used other than large Erlang frameworks.  This
method should return `{:ok, new_state}`.
