---
title: Impressing your friends with Ruby
date: 2012-08-08
---
I've been programing in Ruby for a few years now and along the way I've picked
up a few fun tricks that other programmers rarely seem to know about.  These are
good for showing off, but be careful using them in production code as they may
hiding the meaning of what's going on.

### &method

Most Ruby developers know about calling & on a symbol to turn it into a proc.
This is mostly used in map functions like so:

```ruby
[1,2,3].map(&:to_s) #=> ["1", "2", "3"]
# Is the same as
[1,2,3].map { |num| num.to_s }
```

Symbol to proc creates a proc that expects one argument then calls that method
on that argument. But what if we wanted to do something like:

```ruby
[1, 2, 3].map { |num| something_awesome(num) }
```

Well this can be shortened too!

```ruby
[1, 2, 3].map(&method(:something_awesome)) # Save 4 characters!
```

The `Object#method` method returns a method object corresponding to the symbol
its given.  We then turn that method object into a proc using the & operator.
That proc can then be used by the map function like any other proc.

### concat strings with whitespace

There are a lot of ways to concat strings in Ruby.

```ruby
"abc" + "def"      #=> "abcdef"
"abc" << "def"     #=> "abcdef"
"abc".concat "def" #=> "abcdef"
```

But did you know you can also use whitespace to concat ruby strings?
    
```ruby
"abc" "def" #=> "abcdef"
```

Yep, that works and its valid ruby code.  Why the Ruby developers thought that
this was a good language feature, I don't know.  But its there. This can cause
issues when you're creating an array from strings.

```ruby
# Woops forgot a comma
["a", "b" "c"] #=> ["a", "bc"]
```

### call with current continuation

Call with current continuation, or "callcc", is a feature from Lisp that was
carried over to Ruby.  It is a little hard to explain, so lets give an example
to start.

```ruby
def level_3(cont)
  cont.call("RETURN THIS")
end

def level_2(cont)
  level_3(cont)
  return "NEVER RETURNED"
end

def top_level_function
  callcc { |cc| level_2(cc) }
end

puts top_level_function # => "RETURN THIS"
```

So whats going on here?  The callcc method takes a block, and provides
a Continuation object.  If this continuation object is ever called, the program
will immediately jump from where ever it is, to just outside the callcc block.
This acts much like other ruby control flow statements like `break`, `skip`, and
`retry`.  But instead of just jumping out of the current scope, it can jump as
far as it wants.
