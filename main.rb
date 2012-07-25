require 'rubygems'
require 'sinatra'
require 'kramdown'
require 'builder'
require 'time'
require 'open-uri'
require 'slim'

class Post
  attr_accessor :title, :body, :url, :date
  def initialize(blob)
    path = "posts/#{blob}.md"
    p = blob.split('-')
    @url = '/posts/'+p[0..2].join('/')+'/'+p[3..-1].join('-')
    @title = blob.split('-')[3..-1].join(' ')
    @date = Time.utc(p[2], p[0], p[1], 12)
    @body = Kramdown::Document.new(File.read(path)).to_html
  rescue
    raise Sinatra::NotFound
  end
end

not_found do
  request.xhr? ? slim(:"404", :layout=>false) : slim(:"404")
end

error do
  request.xhr? ? slim(:"500", :layout=>false) : slim(:"500")
end

### Routes ###

# Index Page, lists the last three blog posts
get %r{^(/ajax/)?/?$} do |ajax|
  redirect params[:_escaped_fragment_] if params[:_escaped_fragment_]
  @posts, @ending = next_posts(nil, 3)
  slim(:index, :layout => !ajax)
end

get %r{^/ajax//$} do |ajax|
  redirect params[:_escaped_fragment_] if params[:_escaped_fragment_]
  @posts, @ending = next_posts(nil, 3)
  slim(:index, :layout => !ajax)
end

# About Page, explains what the blog is about
get %r{^(/ajax)?/about/?$} do |ajax|
  @title = "- About"
  slim(:about, :layout=> !ajax)
end

# History Page, lists all of the blog posts with links
get %r{^(/ajax)?/history/?$} do |ajax|
  @title = "- History"
  @history = post_arry.map {|m| [post_title(m), post_url(m)] }
  slim(:history, :layout=> !ajax)
end

# Post Page, displays a single blog post
get %r{^(/ajax)?/posts/(\d+)/(\d+)/(\d+)/([^/]+)/?$} do |ajax, month, day, year, post|
  @post = Post.new( [month, day, year, post].join('-') )
  @title = "- "+@post.title
  slim(:post, :layout=> !ajax)
end

# Pagination, displays the next blog posts, from a certain date
get %r{^(/ajax)?/from/(\d+)/(\d+)/(\d+)/?$} do |ajax, month, day, year|
  ajax ? num = 1 : num = 3
  @title = "- Continued"
  @posts, @ending = next_posts([month,day,year].join('-'), num)
  slim(:from, :layout=> !ajax)
end

### RSS ###
get '/rss.xml' do
  builder do |xml|
    xml.instruct! :xml, :version => '1.0'
    xml.rss :version => "2.0" do
      xml.channel do
        xml.title "Journey to Masterclass"
        xml.description "A blog about stuff."
        xml.link "http://erickoslow-blog.heroku.com/"

        post_arry.each do |post|
          xml.item do
            xml.title post_title(post)
            xml.link "http://erickoslow-blog.heroku.com#{post_url(post)}"
            xml.description from_markdown(post).body
            xml.pubDate Time.parse(post_date(post)).rfc822()
            xml.guid "http://erickoslow-blog.heroku.com#{post_url(post)}"
          end
        end
      end
    end
  end
end


private

### FUNCTIONS ###
def post_url(post)
  p=post.split('-')
  '/posts/'+p[0..2].join('/')+'/'+p[3..-1].join('-')
end

def post_title(post)
  post.split('-')[3..-1].join(' ')
end

def post_date(post)
  p = post.split('-')
  #Year, Month, Day
  [p[2], p[0], p[1]].join('/') 
end

def post_arry
  Dir.glob('posts/*').map {|m| m =~ /\/([^\/]+)\.md$/; $1}.sort_by do |a|
    a = a.split('-')
    # Year, Month, Day
    [a[2], a[0], a[1]]
  end.reverse
end

def from_markdown(thing)
  path = 'posts/'+thing+'.md'
  Post.new( thing )
end

def next_posts(id, num=1)
  post_array = post_arry
  to_return = []
  if id.nil?
    id = post_array[0]
    to_return << from_markdown(id)
    num -= 1
  else
    post_array << id
    post_array = 
      post_array.sort_by {|s| s=s.split('-'); [s[2],s[0],s[1],s.size]}.reverse
  end

  num.times do
    index = post_array.index(id)
    id = post_array[index+1] || (id && break)
    to_return << from_markdown(id)
  end

  ending = post_array[-1] == id ? '<div id="theEnd">That\'s all folks!</div>' : "<div id='next'><a href='/from/#{id.split('-')[0..2].join('/')}'>Next >></a></div>"

  [to_return, ending]
end
