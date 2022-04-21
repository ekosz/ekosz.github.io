---
title: Testing Elixir
date: 2012-07-30
---

When learning a new linage, one of the first steps one needs to take is
learning its testing frameworks. Elixir being a relatively new language, it
only has one ExUnit. In this blog post, I'll walk you through writing your
first tests.

First thing to note are that Elixir tests are written in `.exs` files, not the
standard `.ex` Elixir file format. `.exs` files are written in the Elixir
language, but are never compiled only ever interpreted.

Now lets jump into some code. First lets create a test helper.

    $ mkdir test
    $ touch test/test_helper.exs

    ### Inside test_helper.exs

    ExUnit.start []

Thats all we need to get started. We can later put utility methods in here, if
they're needed. Now lets write a testing module.

    ### Inside adder_test.exs

    Code.require_file "../test_helper", __FILE__

    defmodule Adder.Test do
      use ExUnit.Case, async: true
    end

Here we do a few things. Require the test_helper file we just wrote, create
the module we will fill with tests, and import the ExUnit.Case methods. One
thing to note here is the async option on ExUnit.Case. When set to true, all
the of the tests will run in parallel. Whenever possible set this to true. Lets
write a test.

    test "adds one and one correctly" do
      assert 2 == 1 + 1
    end

Like many other languages ExUnit uses the standard assert clauses, but wraps
them in a test block. We can run this test with the command `elixir test/adder_test.exs`. If everything was written correctly you should see:

    .

    1 test, 0 failures.

Woot! We ran our first Elixir test. Now lets stream line the process with
a shell script.

    # Inside tester.sh

    elixir -r "lib/**/*.ex" -r "test/test_helper.exs" -pr "test/**/*_test.exs"

This script will load every `.ex` file in your lib directory, then require the
test helper, and then load each test file sequentially.

Thats it. Now just `sh tester.sh` to run all your tests. Have fun!
