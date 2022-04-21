---
title: Introduction to Joodo
date: 2012-08-20
---
This week I'm diving head first into Clojure and more specifically web
development in Clojure.  Clojure has a view frameworks to choose from when
working with the web, but I'll be talking about [Joodo](http://www.joodoweb.com/).

Joodo is a lightweight framework with a very small API.  It tries to do the
least amount of work possible then get out of your way.  

### Instillation

First of all you're going to want to have Leiningen 2 installed if its not
already.

```bash
mkdir ~/bin && 
wget --no-check-certificate https://raw.github.com/technomancy/leiningen/preview/bin/lein ~/bin/ && 
chmod 755 ~/bin/lein
```

Next update your `~/.lein/profiles.clj`

```clojure
{:user {:plugins [ [joodo/lein-joodo "0.10.0"] ]}}
```

Now we can create a Joodo project and start the server.

```bash
lein joodo new sample
cd sample
lein joodo server
open "http://localhost:8080"
```

Boom! You're up an running with Joodo. Next we'll talk about the Joodo
directory structure and changes we can make to the configuration to make our
application be more expressive.
