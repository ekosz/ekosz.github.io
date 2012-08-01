---
layout: post
title: static code analysis
---
On the way to being a great programmer, everyone hits the same roadblock.  Code
Smells.  One of the tools I have started using to help me recognize and locate
code smells is "Static Code Analysis".

Static code analysis is the process of running a program that instead of
running your code, looks at how it was written. Though there are many of these
tools out there, the two I've become reliant on are [Reek](https://github.com/troessner/reek) and [Pelusa](https://github.com/codegram/pelusa).

### Reek

Reek is the older of the two tools and provides a good foundation for programmers to
get started with. 

    threebythree_implementations/brute_force_implementation.rb -- 5 warnings:
      TicTacToe::BruteForceImplementation#block_fork! has approx 7 statements (LongMethod)
      TicTacToe::BruteForceImplementation#corner_from_index has approx 6 statements (LongMethod)
      TicTacToe::BruteForceImplementation#each_position calls Board::SIZE.times twice (Duplication)
      TicTacToe::BruteForceImplementation#each_position contains iterators nested 2 deep (NestedIterators)
      TicTacToe::BruteForceImplementation#each_position doesn't depend on instance state (LowCohesion)

Reek looks at ones code, and provides a quick summary for whats wrong.  The
best part of reek, is its [Wiki](https://github.com/troessner/reek/wiki/Code-Smells).  
There one can get detailed descriptions of the code smells it finds, how suggestions 
how how to fix them.

### Pelusa

Pelusa is a relatively new comer to the SCA tools and definitely not for the faint
of heart.  Based on [this blog post](http://binstock.blogspot.com/2008/04/perfecting-oos-small-classes-and-short.html) Pelusa is a harsh grader.

    class GameTree
        ✿ Is below 50 lines ✗
      This class has 63 lines.
        ✿ Uses less than 3 ivars ✗
      This class uses 5 instance variables: @evaluator, @state, @depth, @alpha, @beta.
        ✿ Respects Demeter law ✗
      There are 1 Demeter law violations in lines 123.
        ✿ Doesn't use more than one indentation level inside methods ✗
      There's too much indentation in lines 138, 157.
        ✿ Doesn't use else clauses ✓
        ✿ Doesn't use getters, setters or properties ✓
        ✿ Doesn't mix array instance variables with others ✓
        ✿ Uses descriptive names ✓
        ✿ Methods have short argument lists ✗
      Methods with more than 3 arguments: initialize
        ✿ Doesn't use eval statement ✓

As you can see, Pelusa goes the extra step to make sure your code is following
the very best OO design patterns. Getting a perfect score may be hard, but if
done, your code will thank you.

As one grows as a programmer, they'll probably find that SCA tools become less
useful as they can spots smells easier.  But for new programmers trying to up
their game, I can't suggest them enough.
