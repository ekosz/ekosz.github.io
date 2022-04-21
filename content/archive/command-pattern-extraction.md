---
title: Command patten extraction
date: 2012-08-29
---

In my first iteration of my [Limelight](http://limelight.8thlight.com/) interface to mu TTT program I ended up
putting all of my application logic inside my player classes. Players in
limelight act as controllers to the GUI.

Controllers only have one job. Controllers are translators to the GUI. They first
translate events in the GUI into data the application domain can understand.
Then they translate the result from the domain logic into simple data the GUI
can understand.

Domain logic does not belong in the controller. If it is found there, then it
needs to be extracted. One method of extraction is to use the [command pattern](http://en.wikipedia.org/wiki/Command_pattern).

This is one of the easiest extraction patterns.

1. Create a class who's name is the action we're extracting.
2. Create an execute method inside this class.
3. Copy paste the logic we're extracting from the controller into the execute method.
4. Scan through the copied code and turn local variables into instance variables.
5. Create a constructor for the class that takes each variable, and sets that instance variable.
6. Replace the section of code in the controller with this class.
7. Run tests and make sure the code still works.
8. Refactor.
