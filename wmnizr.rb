require 'sinatra'

def hostname_for(hostname)
  if hostname[0,4] == "www."
    hostname[4,-1]
  else
    hostname
  end
end

class Wmnizr < Sinatra::Base
  before do
    @hostname = hostname_for request.host
    content_type 'text/html', :charset => 'utf-8'
  end

  get '/login' do
    haml :'admin/login', :layout => :'admin/layout'
  end

  post '/login' do
    p env['warden'].authenticate!(:pickle)

    haml :'admin/login', :layout => :'admin/layout'
  end

  get '/admin' do
    @posts = Post.all

    haml :'admin/index', :layout => :'admin/layout'
  end

  get '/admin/posts' do
    @posts = Post.all

    haml :'admin/posts', :layout => :'admin/layout'
  end

  post '/admin/posts' do
    @post = Post.create params[:post]

    redirect "/admin/posts/#{@post.id}"
  end

  get '/admin/posts/:id' do
    @post = Post.first :id => params[:id]

    haml :'admin/single_post', :layout => :'admin/layout'
  end

  get '/admin/posts/:id/edit' do
    @post = Post.first :id => params[:id]

    haml :'admin/post_form', :layout => :'admin/layout', :locals => { :action => "/admin/posts/#{@post.id}", :post => @post }
  end

  post '/admin/posts/:id' do
    @post = Post.first :id => params[:id]

    @post.update(params[:post])

    redirect "/admin/posts/#{@post.id}"
  end

  get '/stylesheets/:stylesheet.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass :"#{@hostname}/#{params[:stylesheet]}", :views => File.join(BASE_PATH, 'sass')
  end


  get '/:year/:permalink' do
    @post = Post.by_year(params[:year]).first :permalink => params[:permalink], :site => @hostname

    haml :"#{@hostname}/single_post", :layout => :"#{@hostname}/layout" 
  end

  get '/:permalink' do
    @post = Post.published.first :permalink => params[:permalink], :site => @hostname

    haml :"#{@hostname}/single_post", :layout => :"#{@hostname}/layout" 
  end

  get '/' do
    @posts = Post.published.all :site => @hostname

    haml :"#{@hostname}/index", :layout => :"#{@hostname}/layout" 
  end
end
