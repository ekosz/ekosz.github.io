---
title: test often, for the sake of your brain
layout: post
---
I run my tests as often as I can.  Even when I've only edited a couple lines of
code, I run my tests.  To me, tests are a way of saving my precious brain
cycles and time.  Looking at different piece of code requires me to load up that
code's mind state which takes a non-zero amount of time.

My current process looks like this.

> 1. load up a piece of code (x time)
> 2. make changes (y time)
> 3. run tests (z time)
> if tests pass, dump memory and move on
> else go back to 2

In this process x is constant and y and z have scalers.

If I didn't run my tests often my process would look more like

> 1. load up a piece of code (x time)
> 2. make changes (y time)
> 3. load up a new piece of code (x time)
> 4. make changes (y time)
> 5. run tests(z time)
> if tests pass, dump memory move on
> else if tests break on code 1, go to 1
> else go to 4

In this process x, y, and z all of scalers.

The problem here is that bugs bubble up.  If I'm working on multiple pieces of
code, I'll have to keep keep dumping and loading new states of mind. The time
it takes to switch states builds up and soon half your day is spent trying to
remember what you were doing the other half.

This is also the reason distraction can be so distributive to work.  When
a developer gets distracted they automatically dump their memory so they can
interpret the distraction.  Then afterwords they need to spend x time to load
up the code again.
