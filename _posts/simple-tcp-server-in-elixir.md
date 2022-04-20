---
title: Simple TCP server in Elixir
date: 2012-07-27
---
One of my favorite functional languages is Erlang.  First created in 1986,
Erlang is a highly concurrent language with high fault tolerance.  It a great
tool to have for any programmer.  That being said, Erlang definitely shows its
age and is missing many features that modern day languages excel at.

That's where the Elixir project comes in.  Elixir is a language built on the
Erlang VM, that keeps all of the amazing abilities of Erlang, but adds features like;
functional meta-programming, polymorphism via Clojure-like protocols, and hashes
(or maps as they're called in other languages).

Erlang is known for its server capabilities, and here I'm going to show just how
easy it is to create a simple TCP server in Elixir.

First we declare a name-space for our functions.

    defmodule TCPServer do
    end

Then create a listen function that takes a port.

    defmodule TCPServer
      def listen(port) do
      end
    end

Now we can fill in that method with some content.  We will be using the
gen\_tcp module from Erlang.  The way we call down to Erlang from Elixir is to
just call the module as a atom.

    def listen(port) do
      tcp_options = [:list, {:packet, 0}, {:active, false}, {:reuseaddr, true}]

      {:ok, l_socket} = :gen_tcp.listen(port, tcp_options)

      do_listen(l_socket)
    end

The first line just declares some options for the `:gen_tcp.listen` method.
The second line assign the `l_socket` variable.  Finally we call the unwritten
method `do_listen` with our new `l_socket`.  Lets write that.

    defp do_listen(l_socket) do
      {:ok, socket} = :gen_tcp.accept(l_socket)

      spawn(fn() -> do_server(socket) end)

      do_listen(l_socket)
    end

First we grab a real socket from our `l_socket` when someone connects. Then we
spawn our server from that socket.  Finally we loop back around a continue to
listen to that port. Finally lets write the meat of our TCP Server.

    defp do_server(socket) do
      case :gen_tcp.recv(socket, 0) do
        
        { :ok, data } ->
          :gen_tcp.send(socket, data)
          do_server(socket)

        { :error, :closed } -> :ok
      end
    end

We create a case statement around the data we receive from the socket.  When they
pass us good data, we just echo it back to them, then continue to listen.  When
we get the signal that they disconnected, we drop out of our loop and the thread
dies.

Thats it!  The entire program is 20 lines long, and very readable. I will
continue to update this blog with more complex examples of what you can do with
Elixir.
