---
title: Elixir make files
date: 2012-07-31
---

One of the common practices in Elixir is to use Makefiles and the Make compiling
utility. Make was first released in 1977 and can be found installed on almost
all \*nix systems. Make uses a series of commands to compile projects. These
commands are written in a Makefile. When Make runs, it checks to see if
a Makefile exists in the current directory, and if so uses it.

Makefiles can be tricky if you don't know what you're doing, so in this post
I'll try an explain the base Makefile I use in my Elixir projects.

First thing to do is pick a location for our compiled code. I normally use the
ebin directory. Lets set that to a variable.

    EBIN_DIR=ebin

Variables in Make are set using capital letters. Next we need to write our compile
task.

    compile: ebin

    ebin: lib/*.ex
      @ rm -f ebin/::*.beam
      @ echo Compiling ...
      @ mkdir -p $(EBIN_DIR)
      @ touch $(EBIN_DIR)
      elixirc lib/**/*.ex -o $(EBIN_DIR)
      @ echo

Tasks are written with the task name on the left, then a series of targets on
the right. A target can be a group of files, or another task. If the target is
a group of files, the task will only execute if the files have changed since it
last ran.

In this case our compile task's only target is the ebin task, though more can
be added later. The ebin task watches all of the `.ex` files in the lib
directory. If any of them have changed since the last time the task was run, it
will remove all of the old compiled code, make sure the ebin directory
exists, then use the `elixirc` command to compile the code and output the
result to the ebin.

Using make we can also create a test task.

    test: compile
      @ echo Running tests ...
      time elixir -pa ebin -r "test/**/*_test.exs"
      @ echo

Our test task makes sure the code is compiled, the uses the regular `elixir`
command to load up the compiled code, then execute all of the tests.

Using Make, we can continue to add tasks to our program automating any
procedure we seem to be doing over and over again.
