---
layout: post
title: pain based programming
---
According to [Forbs](http://www.forbes.com/sites/nathanfurr/2011/09/02/1-cause-of-startup-death-premature-scaling/), the number one cause of death is premature scaling.
I would like to venture that, like startups, the number one cause for
failure in software projects is premature flexibility.

As programmers we are constantly sacrificing simplicity for flexibility.  But
when do we make these decisions? Good refactoring techniques teach us to keep
code repeat low, and separate concerns whenever possible. We introduce
interfaces and split large classes into smaller ones.

While we have good intentions many of us find our projects getting out of hand
even when following all of the "proper" techniques.  The problem comes from the
fact that we are introducing this extra complexity without first feeling the
pain from the code we are trying to "fix".

Don't add flexibility to code without first feeling the pain of their
rigidity.  When pain based programming, each of your refactorings should reduce a 
pain you're feeling from your code.  If you come out of a refactoring step and
the pain is still there, the refactoring was wrong.  Don't refactor if there is
no pain yet, even if you have a feeling that there will a problem later.  You
may be right, but often you're not.
