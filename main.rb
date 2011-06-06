require 'rubygems'
require 'sinatra'
require 'kramdown'
require 'builder'
require 'time'
require 'open-uri'
require 'slim'

class Post
  attr_accessor :title, :body, :url
  def initialize(title, body, url)
    @title, @body, @url = title, body, url
  end
end

not_found do
  slim :"404"
end

error do
  slim :"500"
end

### Routes ###

get '/' do
  redirect params[:_escaped_fragment_] if params[:_escaped_fragment_]
  @posts, @ending = next_posts(nil, 3)
  slim :index
end

get %r{(/ajax)?/about/?} do |ajax|
  @title = "- About"
  ajax ? slim(:about, :layout=>false) : slim(:about)
end

get %r{(/ajax)?/history/?} do |ajax|
  @title = "- History"
  @history = gen_post_arry.map {|m| [gen_post_title(m), gen_post_url(m)] }
  ajax ? slim(:history, :layout=>false) : slim(:history)
end

get %r{(/ajax)?/posts/(\d+)/(\d+)/(\d+)/([^/]+)/?} do |ajax, month, day, year, post|
  @post = from_markdown( [month, day, year, post].join('-') )
  @title = "- "+@post.title
  ajax ? slim(:post, :layout=>false) : slim(:post)
end

get %r{(/ajax)?/from/(\d+)/(\d+)/(\d+)/?} do |ajax, month, day, year|
  @title = "- Continued"
  @posts, @ending = next_posts([month,day,year].join('-'), 3)
  ajax ? slim(:from, :layout=>false) : slim(:from)
end

### AJAX CALLS ###

get '/ajax//' do
  @posts, @ending = next_posts(nil, 3)
  slim :index, :layout => false
end

### RSS ###
get '/rss.xml' do
  builder do |xml|
    xml.instruct! :xml, :version => '1.0'
    xml.rss :version => "2.0" do
      xml.channel do
        xml.title "Blog Name Here"
        xml.description "A blog about stuff."
        xml.link "http://blognamehere.com"

        gen_post_arry.each do |post|
          xml.item do
            xml.title gen_post_title(post)
            xml.link "http://blognamehere.com#{gen_post_url(post)}"
            xml.description from_markdown(post)
            xml.pubDate Time.parse(gen_post_date(post)).rfc822()
            xml.guid "http://blognamehere.com#{gen_post_url(post)}"
          end
        end
      end
    end
  end
end


private

### FUNCTIONS ###
def gen_post_url(post)
  p=post.split('-')
  '/posts/'+p[0..2].join('/')+'/'+p[3..-1].join('-')
end

def gen_post_title(post)
  post.split('-')[3..-1].join(' ')
end

def gen_post_date(post)
  p = post.split('-')
  #Year, Month, Day
  [p[2], p[0], p[1]].join('/') 
end

def gen_post_arry
  Dir.glob('posts/*').map {|m| m =~ /\/([^\/]+)\.md$/; $1}.sort_by do |a|
    a = a.split('-')
    # Year, Month, Day
    [a[2], a[0], a[1]]
  end.reverse
end

def from_markdown(thing)
  path = 'posts/'+thing+'.md'
  begin
    Post.new(gen_post_title(thing), Kramdown::Document.new(File.read(path)).to_html, gen_post_url(thing))
  rescue
    raise Sinatra::NotFound
  end
end

def next_posts(id, num=1)
  post_array = gen_post_arry
  to_return = []
  if id.nil?
    id = post_array[0]
    to_return << from_markdown(id)
    num -= 1
  else
    post_array << id
    post_array = post_array.sort_by {|s| s=s.split('-'); [s[2],s[0],s[1],s.size]}.reverse
  end

  num.times do
    index = post_array.index(id)
    id = post_array[index+1] || (id && break)
    to_return << from_markdown(id)
  end

  ending = post_array[-1] == id ? '<div id="theEnd">That\'s all folks!</div>' : "<div id='next'><a href='/from/#{id.split('-')[0..2].join('/')}'>Next >></a></div>"

  [to_return, ending]
end
