def hostname_for(hostname)
  if hostname[0,4] == "www."
    hostname[4,-1]
  else
    hostname
  end
end

class Wmnizr < Sinatra::Base
  include Cache
  helpers AuthenticationHelpers
  before do
    @hostname = hostname_for request.host
    @site = Site.first(:hostname => @hostname) || Site.new
    content_type 'text/html', :charset => 'utf-8'
  end

  get '/login' do
    haml :'admin/login', :layout => :'admin/layout'
  end

  post '/login' do
    user = env['warden'].authenticate

    redirect '/admin' unless user.nil?
    haml :'admin/login', :layout => :'admin/layout'
  end

  get '/logout' do
    logout_user!
    redirect '/login'
  end

  get '/admin' do
    require_authentication

    @posts = Post.all
    haml :'admin/index', :layout => :'admin/layout'
  end

  get '/admin/posts' do
    require_authentication

    @posts = Post.all
    haml :'admin/posts', :layout => :'admin/layout'
  end

  post '/admin/posts' do
    require_authentication

    @post = current_user.posts.create params[:post]
    redirect "/admin/posts/#{@post.id}"
  end

  get '/admin/posts/:id' do
    require_authentication

    @post = Post.first :id => params[:id]
    haml :'admin/single_post', :layout => :'admin/layout'
  end

  get '/admin/posts/:id/edit' do
    require_authentication

    @post = Post.first :id => params[:id]
    haml :'admin/post_form', :layout => :'admin/layout', :locals => { :action => "/admin/posts/#{@post.id}", :post => @post }
  end

  post '/admin/posts/:id' do
    require_authentication

    @post = Post.first :id => params[:id]
    @post.update(params[:post])

    redirect "/admin/posts/#{@post.id}"
  end

  get '/stylesheets/:stylesheet.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass :"#{@hostname}/stylesheets/#{params[:stylesheet]}"
  end

  get '/feed/atom.xml' do
    content_type 'application/atom+xml', :charset => 'utf-8'

    cache @site.atom_feed_from(Post.all(:published_at.not => nil, :site => @hostname, :order => [ :published_at.desc ]))
  end

  get '/page/:page' do
    @page = params[:page].to_i
    @posts = Post.published.all :site => @hostname, :limit => 5, :offset => @page * 5, :order => [ :published_at.desc ]

    cache(haml(:"#{@hostname}/index", :layout => :"#{@hostname}/layout"))
  end

  get '/:year/:permalink' do
    @post = Post.by_year(params[:year]).first :permalink => params[:permalink], :site => @hostname

    unless @post.nil?
      cache(haml(:"#{@hostname}/single_post", :layout => :"#{@hostname}/layout"))
    else
      status(404)
    end
  end

  # compatibility with mephisto / wordpress routes
  get '/:year/*/:permalink' do
    @post = Post.by_year(params[:year]).first :permalink => params[:permalink], :site => @hostname

    unless @post.nil?
      redirect @site.url_for_post(@post), 301
    else
      status(404)
    end
  end

  get '/:permalink' do
    @post = Post.published.first :permalink => params[:permalink], :site => @hostname

    cache(haml(:"#{@hostname}/single_post", :layout => :"#{@hostname}/layout")) unless @post.nil?
  end

  get '/' do
    @posts = Post.published.all :site => @hostname, :limit => 5, :order => [ :published_at.desc ]

    cache(haml(:"#{@hostname}/index", :layout => :"#{@hostname}/layout"))
  end

end
