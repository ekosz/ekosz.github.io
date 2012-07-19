This week I was playing around with creating a complex terminal game.
I immediately though about Curses.

If you don't know Curses is an old C library for manipulating text in the
terminal.  It, and its newer brother NCurses, has been used to create
applications from famous games to text editors.

### The Good

I found out that Curses is actually built into most distributions of Ruby.
That means getting started with Curses is only a require away.

### The Bad

Seeing how Curses is a 30+ year old library, its syntax is very un-ruby like and
needs a bit of knowhow.

The first thing to when learning how to use Curses with Ruby is read the
[documentation on
ruby-doc.org](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/curses/rdoc/Curses.html).
The documentation there gives some sample problems, and an intro to the syntax.
Unfortunately, other than the sample problems the documentation is sadly
lacking.  Here's some features that the docs don't cover.

### Colors

Colors in Curses a defined in terms of color\_pairs. A color\_pair is two
colors, the first being the foreground color and the second being the
background.  Color pairs must be defined before they are used.

    Curses.init_pair(COLOR_BLUE,COLOR_BLUE,COLOR_BLACK)

This will create the COLOR\_BLUE color pair with a blue foreground and a black
background. Using this color pairs have a funny syntax as well.

    Curses.attron(color_pair(COLOR_BLUE)|A_NORMAL) {
      Curses.addstr("I'm in blue!!")
    }

Curses.attron takes a hash of attributes that it then applies to the block it
receives. The color\_pair and the A\_NORMAL constant work together to create
a full attributes hash thats needed.

It my next post I'll talk about speed.
