---
title: Don't settle for 99%
date: 2012-08-07
---
The goal for unit testing is 100% test coverage, but most developers will tell
you that not everything will be able to be tested.  Most programmers settle for
99% coverage.  Don't do that.

There is no good enough when it comes to unit testing.  Every line of code
of your program should be executed at least once.  Lets take a look at an 
example of code that is normally not tested.

{% highlight ruby %}
def get_move_from_user
  cords = @io.gets.chomp

  raise IllegalMove.new("Bad input") unless cards =~ /^\d+$/

  cords
rescue IllegalMove => error
  display_text "Illegal Move: #{error.message}. Please try again"
  retry
end
{% endhighlight %}

This example shows a rescue block with a retry.  This is hard to test, as there
is no good way to make sure that the exception was raised. Instead of skipping
those two lines, we can create a IOMock object that takes an array of input to
return one at a time.

{% highlight ruby %}
class IOMock
  def initialize(input)
    @input = Array(input)
  end

  def gets
    @input.pop
  end
end
{% endhighlight %}

This now allows us to pass in multiple inputs, the first failing and the second
succeeding.

{% highlight ruby %}
def test_get_move_from_user
  mover = Mover.new( IOMock.new(['1', 'a']) )
  assert_equal '1', mover.get_move_from_user
end
{% endhighlight %}

Suddenly we're two lines closer to 100%.

Don't settle.  There is almost always a way to get 100%, and if not, you may be
doing something wrong.
