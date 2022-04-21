---
title: Test driven Clojure part II
date: 2012-10-02
---

In my last post we talked about the tools we're going to use for this project.
Now we're going to get set up with these tools so we can get coding next.

### Installing Leiningen

The first thing we'll need is Leiningen, as it will be the tool to download the
rest of our dependencies.

If you're worried about control of your system you can go to Leiningen's
[Github Page](https://github.com/technomancy/leiningen) and get detailed
instructions on installation. For everyone else, running the following command
should get you setup.

```bash
$ mkdir ~/bin &&
cd ~/bin &&
wget https://raw.github.com/technomancy/leiningen/preview/bin/lein &&
chmod 755 lein
```

Now we need to add our newly created ~/bin directory to our load path.
I normally add this to my .profile file in my home directory. If you use
a shell that doesn't use the .profile library, you probably know where this
should go instead. If you don't know if your shell uses .profile, then it
probably does.

Either add the following to your existing .profile file, or create it in your
home directory.

```bash
# Add user bin files
export PATH=/Users/ekoslow/bin:$PATH
```

If everything went well, after opening up a new console you should be able to
do something like this:

```bash
$ lein -v
Leiningen 2.0.0-preview7 on Java 1.6.0_33 Java HotSpot(TM) 64-Bit Server VM
```
