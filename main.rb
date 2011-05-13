require 'rubygems'
require 'sinatra'
require 'kramdown'
require 'builder'
require 'time'

not_found do
  '<div id="404">404 Not Found</div>'
end

error do
  '<div id="error">Fuck, you broke it!</div>'
end

### Real Calls ###

get '/' do
  full_html(index_content)
end

get '/about' do
  full_html(about_content)
end

get '/history' do
  full_html(history_content)
end

get '/posts/:month/:day/:year/:post' do |month, day, year, post|
  full_html(from_markdown( [month, day, year, post].join('-') ))
end

get '/from/:month/:day/:year/' do |month, day, year|
  full_html( next_post([month,day,year].join('-'), 3) )
end

### AJAX CALLS ###

get '/ajax//' do
  index_content
end

get '/ajax/about' do
  about_content
end

get '/ajax/history' do
  history_content
end

get '/ajax/posts/:month/:day/:year/:post' do |month, day, year, post|
  from_markdown( [month, day, year, post].join('-') )
end

get '/ajax/from/:month/:day/:year' do |month, day, year|
  next_post([month,day,year].join('-'))
end

get '/rss.xml' do
  builder do |xml|
    xml.instruct! :xml, :version => '1.0'
    xml.rss :version => "2.0" do
      xml.channel do
        xml.title "Blog Name Here"
        xml.description "A blog about stuff."
        xml.link "http://blognamehere.com/"

        gen_post_arry.each do |post|
          xml.item do
            xml.title gen_post_title(post)
            xml.link "http://blognamehere.com/#{gen_post_url(post)}"
            xml.description from_markdown(post)
            xml.pubDate Time.parse(gen_post_date(post)).rfc822()
            xml.guid "http://blognamehere.com/#{gen_post_url(post)}"
          end
        end
      end
    end
  end
end


private

### SPECAIL PAGES ###
def index_content
  "<div id='title'>blog name here!</div>\n"+next_post(nil, 3)
end

def about_content
  from_markdown('about', './')
end

def history_content
  to_return = []
  to_return << '<div id="history">'
  post_array = gen_post_arry

  post_array.each do |post|
    to_return << "<div class='post'><h2>
    <a href='#{gen_post_url(post)}'> #{gen_post_title(post)}
    </a></h2></div>"
  end
  to_return << '</div>'

  to_return.join("\n")
end

### FUNCTIONS ###
def gen_post_url(post)
  p=post.split('-')
  'posts/'+p[0..2].join('/')+'/'+p[3..-1].join('-')
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

def from_markdown(thing, path=nil)
  path = path ? path+thing+".md" : 'posts/'+thing+'.md'
  begin
    '<div class="post">'+Kramdown::Document.new(File.read(path)).to_html+'</div>'
  rescue
    raise Sinatra::NotFound
  end
end

def top_half
  @tophalf ||=  File.read(File.join('public', 'index.html')).split(/<div id="main" role="main">/)[0]+'<div id="main" role="main">'
end

def bottom_half
  @bottomhalf ||= File.read(File.join('public', 'index.html')).split(/<div id="main" role="main">/)[1]
end

def full_html(snippet)
  top_half+snippet+bottom_half
end

def next_post(id, num=1)
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

  to_return.join("\n")+ending
end
