OR

Why the code for this blog looks like crap
------------------------------------------

When first getting into Ruby, I thought Rails was coolest thing since dynamic
variables.  It was pure magic.  Using a complicated mix of meta-programming and
Ruby Ninjaing in the background, Rails allows the average developer to do really
complex things with only a few commands.  And that was awesome.

Today though, as much magic as Rails gives you, I feel that it really restricts
your ability to be expressive in your design.  For example, when writing this
blog, I used a technique where I duplicated each route.  One route for AJAX calls,
one for regular calls.

    get '/posts/:m/:d/:y/:p' do |month, day, year, post|
      full_page get_post [month, day, year, post].join('-')
    end

    get '/ajax/posts/:m/:d/:y/:p' do |month, day, year, post|
      get_post [month, day, year, post].join('-')
    end

This was really simple.  `get_post` returns the html needed for a single post,
and `full_page` wraps the HTML given to it in everything outside of the main
div.

If I wanted I could have reduced the line count even further with some regex.

    get %r{^\/(ajax\/)?posts\/(\d+)\/(\d+)\/(\d+)\/([^\/]+)$} do |ajax, month, year, day, post|
      post = get_post [month, day, year, post].join('-')
      ajax.empty? ? full_page post : post
    end

Though for 2 extra lines, you get a lot more readability.  BUT, the power it
still there if you want to wield it.

If I wanted to do this in Rails, it wouldn't nearly feel as fun and free
spirited.  I would have to create a couple controllers, break REST 
(which I don't know if it is just me, but I feel guilty doing in a Rails app)
create a Post model, fiddle around trying to serve AJAX content, and generally
not have such a free experience.

\_why is one of my all time heroes when it comes to programming. His opinion was that coding
is much more of an art than a business. Sure its a lot safer to write unit
tests, and have these standard sub-systems for everything, but what if
we just want to express ourselves in our code?  What if I don't care about all
the edge cases that could cause my code to blow up, I just want to take
a journey to get someplace?

Rails seems like ponies and rainbows at first, but then you realize after
a while its all just a business framework like any other.  And you know,
thats fine if I'm writing something for a client.  I want that safety and
structure. I want that sense of control over my application.  But, I feel that
as programmers, we forget that coding just for the feeling of creating something
and leaving all of our "business think" back in the office, is a wonderful
thing.


I would recommend to everyone to touch a file, `require 'sinatra'` and go wild.
Create something, just because you can.  And thats awesome.
