---
layout: post
title: endless pagination in jekyll
---
Yesterday I decided to move my blog over from my own custom solution to [Jekyll](https://github.com/mojombo/jekyll/).
The process mostly involved renaming and shuffling a lot files
around. After 20 mins I was able to start the Jekyll server and saw my blog, but it 
was missing its endless pagination I had built into the last version.  Some quick 
Googling showed a distinct lack of endless pagination in Jekyll, so I 
decided to reimplement it myself.

The first thing needed was to add pagination to the \_config.yml file.

    paginate: 3

And then add the paginate link to the bottom of the index page.

    {{ "{% raw " }}%}
    {{ "{% if paginator.next_page " }}%}
    <div id='next'>
      <a href="/page{{paginator.next_page}}">Next >></a>
    </div>
    {{ "{% endif " }}%}
    {{ "{% endraw " }}%}

Now to add some javascript that would replace the next link with the posts from
the next page when the user scrolled to it.

    var rebind = function() {
      $("#next").appear(function() {
        var self = this;
        $(self).fadeOut(function() {
          $.get($("#next a").attr('href'), function(data) {
            $(self).remove();
            $("#main").append($(data).find("#posts"));
            rebind();
          });
        });
      });
    }

This code finds the \#next element and attaches a function to its appear event.
That function fades out the element, grabs the HTML from the page its pointing
to, removes the element, appends the \#posts from that page to the \#main
element, and finally rebinds to the next \#next element.

Wallah! Endless pagination with Jekyll in 12 lines of code.
