require 'sinatra'

def template_folder_for(hostname)
  case hostname
    when /\Alocalhost\Z/
      "foo"
    when /\Asymbolya\.local\Z/
      "bar"
    else
      "default"
  end
end

def hostname_for(hostname)
  p hostname
  if hostname[0,4] == "www."
    hostname[4,-1]
  else
    hostname
  end
end

class Wmnizr < Sinatra::Base
  before do
    @template_folder = template_folder_for request.host
    @hostname = hostname_for request.host
  end

  get '/admin' do
    #p request["SERVER_NAME"]
    @posts = Post.all

    haml :'admin/index'
  end

  post '/admin/posts' do
  end

  put '/admin/posts/:id' do
  end

  get '/admin/posts/:id' do
  end

  get '/:year/:permalink' do
    @post = Post.by_year(params[:year]).first :permalink => params[:permalink], :site => @hostname

    haml :"#{@hostname}/single_post.html", :layout => :"#{@hostname}/layout.html" 
  end

  get '/:permalink' do
    @post = Post.published.first :permalink => params[:permalink], :site => @hostname

    haml :"#{@hostname}/single_post.html", :layout => :"#{@hostname}/layout.html" 
  end

  get '/' do
    @posts = Post.published

    haml :"#{@hostname}/index.html", :layout => :"#{@hostname}/layout.html" 
  end
end
