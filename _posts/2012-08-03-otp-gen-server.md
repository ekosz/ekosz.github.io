---
layout: post
title: "OTP: gen server"
---
This will be the first of many posts coming up on Erlang's OTP library. If
you have never heard of OTP, let me explain.  When Erlang was first introduced
in the 80s certain patterns emerged over and over again. These patterns were
then extracted into a common library named, "The Open Telecom Protocol", or OTP.
After 30 years OTP now has little to do with the Telecom, but the named has
stuck.

OTP provides powerful abstractions to complex patterns and can make
development much easier as a Erlang or Elixir developer.  This post will cover
one of the most commonly module of OTP, gen\_server.

As you may know, there is no global state in Erlang. While this alleviates much
of the headaches one might get with OO languages, this does create a challenge
when state must be shared across systems.  Lets use the real life example of
Elixir's ExUnit testing framework. If you need a refresher on how ExUnit works
read up on it [here](http://ekosz.github.com/2012/07/30/testing-elixir.html).

ExUnit runs in to phases, setup and test execution.  During the setup phase,
ExUnit needs to keep track of every module that uses ExUnit and whether or not
the tests in that module should be run synchronously or asynchronously. These 
modules will then be used throughout ExUnit.  Without global state we would need to
pass these modules around throughout the program adding an extra parameter to
many methods.  One could see how this could get out of hand very quickly.  This
is where gen\_server comes in.

gen\_server lets Erlang and Elixir programs fake global state. Lets write
a simple program to work off of.

    defmodule Incrementor do
      
      use GenServer.Behavior

      defrecord State, counter: 0

      # Callbacks

      def init(_args) do
        {:ok, State.new}

      def handle_call(:add, _from, state) do
        new_state = state.increment_counter
        {:reply, new_state.counter, new_state}
      end

      def handle_call(request, from, state) do
        super(request, from, state)
      end

    end

    # In iex

    :gen_server.start_link({ :local, Incrementor }, Incrementor, [], [])
    :gen_server.call(Incrementor, :add) #=> 1
    :gen_server.call(Incrementor, :add) #=> 2
    :gen_server.call(Incrementor, :add) #=> 3

OK, what did we do there?  First thing was create a module and use the
GenServer behavior.  That notifies the Erlang VM that this module will respond to
certain methods that the gen\_sever module expects much like an interface in
OO languages. Next we define a record that our server will use internally for
record keeping. Finally we get to the meat of the server, the callbacks.

These are the methods that gen\_server will use to customize its behavior. The
init method takes some arguments (that we don't use here), and expects
a response of `{:ok, some_initial_state}`.  This will set the initial state of
the server.  Next we have handle\_call.  Handle call takes a method thats being
called, who is calling the method, and the current state of the server.  It
expects something will happen inside the method, then a response of 
`{:reply, the_result, the_new_state_of_the_server}`.  Our server patterns
matches of the :add method, and supers all other method calls.

Using this pattern, the server will always have a state and that state can then
be queried by outside modules.

In my next posts, I'll go over some of the other call backs our server can
implement for more dynamic behavior.
