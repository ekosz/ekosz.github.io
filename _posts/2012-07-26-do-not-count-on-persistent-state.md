---
layout: post
title: do not count on persistent state
---
Today I finished moving my Tic Tac Toe program to the web. Before the game ran
on a loop, and a single game object was constantly fed new moves.  You can't do
this with web based UI. Every web request starts with a blank slate.  There is
no persistence between requests.

Don't fall into the trap of expecting your objects to always be there.
Netflix forces their developers to not relay on any object or service.  They
created the program
[Chaos Monkey](http://techblog.netflix.com/2010/12/5-lessons-weve-learned-using-aws.html).
Chaos Monkey randomly kills instances and services running on Netflix's
servers.  This way, code must be written in a way that does not assume
persistence.

Code written this way ends up being more robust, and can interface with more
mores of communication.
