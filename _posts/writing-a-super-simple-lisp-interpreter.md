---
title: Writing a super simple lisp interpreter
date: 2012-10-16
---
It seems that its every programmers right of passage to write their own lisp
interpreter.  What most beginner programmers don't realize is just how easy this
feet can be.  Here I'll demonstrate how to create one of these interpreters in
less than 100 LOC.

### The lexer

First part of any interpreter is the lexer.  The lexers job to is to read
a string and turn it into a stream of tokens for the next part of the
interpreter.  This can be done in a simple Regex statement.

Lets first write some tests to make sure that our lexer is working.

{% highlight ruby %}
def assert(a,b)
  fail "expected #{a.inspect}, got #{b.inspect}" unless a == b
end

assert(["1"], lex("1"))
assert(["1", "abc"], lex("1 abc"))
assert(%w[ ( 1 abc ) ], lex("(1 abc)"))
assert(%w[ (= 2 ( + 1  1 ) ) ], lex("(= 2 (+ 1 1))"))
{% endhighlight %}

Alright this should handle all of the use cases of our lexer.  Now lets get
some of these tests passing.

{% highlight ruby %}
def lex(string)
  string.scan(/\w+|[\(\)\+=]/)
end
{% endhighlight %}

Thats all we need to get our tests passing.  These regex tokenizes our string
using words, parentheses, plus signs and equal signs.

Now that the lexer is written we can write our parser.  The parser takes in the
token from our lexer, and turns them into s-expressions that our interpretor
can use. Lets write some tests for our parser.

{% highlight ruby %}
assert(1, parse("1"))
assert(:abc, parse("abc"))
assert([1], parse("(1)"))
assert([:"=", 2, [:+, 1, 1]], parse("(= 2 (+ 1 1))"))
{% endhighlight %}

We want our parser to treat our numbers as numbers and everything else as
symbols.  We also want it to create arrays as the s-expression forms.
Implementing this it a bit more complicated but still reasonable.

{% highlight ruby %}
class Parser

  def initialize(tokens)
    @tokens = tokens
    @pos = 0
  end

  def parse
    t = next_token

    return if t == ")"

    if t == "("
      array = []
      while(parsed = parse)
        array << parsed
      end
      return array
    end

    Integer(t) rescue t.to_sym
  end

  private

  def next\_token
    @tokens[@pos].tap { @pos += 1 }
  end

end

def parse(string)
  Parser.new(lex(string)).parse
end
{% endhighlight %}

The parser iterates over the tokens.  When it finds a open parenthesis, it
starts up a array and starts shovelling parsed tokens into it until it finds
a closing parenthesis.  Otherwise it tries to convert the token into an
Integer.  Failing that it turns the token into a symbol.

Now that our string has been lexed, then parsed into s-expressions we can
finally interpret the results.  Interpreters can get as complicated as you
want, but for our purposes we're only going to support adding and comparing.
Again we're going to start with our tests.

{% highlight ruby %}
assert(1, lisp("1"))
assert(2, lisp("(+ 1 1)"))
assert(true, lisp("(= 2 (+ 1 1))"))
assert(false, lisp("(= 3 (+ 1 1))"))
{% endhighlight %}

And for the interpreter itself.

{% highlight ruby %}
class Interpreter
  
  def initialize(expressions)
    @expressions = expressions
  end

  def interpret(expression = @expressions)
    if expression.is_a? Array
      command = expression.first
      return case(command)
             when :+
               interpret(expression[1]) + interpret(expression[2])
             when :=
               interpret(expression[1]) == interpret(expression[2])
             else
               raise "Unknown command: #{command.to_s}"
             end
     end

     expression
  end

end

def lisp(string)
  Interpreter.new(parse(string)).interpret
end
{% endhighlight %}

This interpreter has no idea of variables or state, but it works for our
purposes.  From here we'd implement tracking the current environment and
removing the hard coded functions.
