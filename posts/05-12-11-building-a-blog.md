There comes a time in every up and coming web developer's life that he realizes
that he/she needs a blog.  And at that time they know that there are plenty of
off the shelf blogging platforms, but in their heart of hearts they know they must build
their own. And so thats what I did.

I decided to make single web application, mostly inspired by the amazing guys
over at [9Elements](http://www.9elements.com/). I've never really played with
AJAX heavy applications before and figured this would be an easy place to
start. On the backend I have [Sinatra](http://www.sinatrarb.com/) listening to HTTP
calls, and on requests starting with `/ajax/` it serves up only the meat of the
desired page, instead of the whole package.  The posts themselves are written in
[Markdown](http://daringfireball.net/projects/markdown/) and stored as plain
files. Sinatra uses [Kramdown](http://kramdown.rubyforge.org/) as its markdown
processor, as it is the fastest one to my knowledge.

I wanted the blog to be as simple as possible, so all of the metadata about the
posts is stored in the name of the files.  For example, the name of this file
is `05-12-11-building-a-blog.md`.  This gives the date for the application to
sort posts by, as well as the title to display.

As for 3rd party tools I used for this project, I am using [jQuery](http://jquery.com/),
[HTML 5 Boilerplate](http://html5boilerplate.com/), and a jQuery plug-in,
[jQuery-Appear](http://code.google.com/p/jquery-appear/) for the automatic
loading of posts as one scrolls through the index.

As for the front end, I wanted to reflect my backend ideas about simplicity in
the look and feel of the site. I choose to go with a simple color scheme of
Black, White, and Light Blue. 

As for the fonts I recently watched the
[presentation from Google.io](http://www.youtube.com/watch?v=QTX1lU97z08) on
Google web fonts. I decided to try out the [web font previewer](http://www.google.com/webfonts/preview) 
and was blown away how easy it was to find the `line-height`, `letter-spacing`, and
`word-spacing` that I wanted. I also found a little trick that came in handy.
For fonts that aren't in Google's font library, like the font I'm using here,
`Helvetica Nue`, I still wanted to use the font previewer.  So, I used the
inspector tool to manually change the `font-family` to what ever I wanted to
test.

Finally for the header menu and footer, I took inspiration from [Coffee Script's
Website](http://jashkenas.github.com/coffee-script/). I really liked the way
one could scroll through a long document without the menu seeming too
intrusive.  I also added a fade-out to the bottom of the page, so that the
footer could travel with the page as well.


For a compleate look at the website internals check it out on [GitHub](https://github.com/ekosz/Personal-Blog), 
and maybe mention a couple things I could have done better.  

Overall I'm really happy with how it turned out.  I'm still not the best
developer, and I'm far from a decent designer, but this is something that
I wouldn't mind showing off.
