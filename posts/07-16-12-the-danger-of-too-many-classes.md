In my last post I talked about refactoring its advantages.  But there is
a danger of refactoring too much.  By following all the right rules, even while
supposedly doing the right thing, your code may become a mess.

This happened to me.  Using the two tools I mentioned, Pelusa and Reek, I had
refactored one of my algorithms from class to 6, and doubled my code size.
Every class was shorter, but combined they caused a new problem.

As programmers, we have to juggle many concepts at the same time while solving
a problem.  Each class I introduced added another ball I had to mentally keep
track of. Eventually I couldn't remember the difference between GameState and
GameMove and when I should use one or the other. 

The beauty of refactoring comes from its balance.  The goal of refactoring is to
make your code more expressive and understandable.  It is very easy to refactor
too much and too far and the code emerges more scattered and confusing than
any time before.

Before you extract another class ask yourself, does this make my problem
easier to understand.  If not, you're doing something wrong.
