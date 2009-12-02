require File.expand_path(File.join(File.dirname(__FILE__), "test_bootstrap.rb"))
require File.expand_path(File.join(File.dirname(__FILE__), '..', "wmnizr.rb"))
require 'rack/test'

::Wmnizr.use Rack::Session::Cookie

::Wmnizr.use Warden::Manager do |manager|
  manager.default_strategies :bcrypt_password
  manager.failure_app = ::Wmnizr
end

class TestHosts < WmnizrTest
  include Rack::Test::Methods

  def app
    ::Wmnizr
  end

  def before
    @user = User.create(:login => 'fanel', :password => 'pitulice')
    @post = Post.create
  end

  def test_redirected_to_login_when_requesting_admin_bits
    get '/admin'
    assert_equal 302, last_response.status

    get '/admin/posts'
    assert_equal 302, last_response.status

    post '/admin/posts'
    assert_equal 302, last_response.status

    get "/admin/posts/#{@post.id}"
    assert_equal 302, last_response.status

    get "/admin/posts/#{@post.id}/edit"
    assert_equal 302, last_response.status

    post "/admin/posts/#{@post.id}"
    assert_equal 302, last_response.status
  end

  def test_does_ok_when_logged_in
    # cheesy rack session id bug down here, do investigate :3
    post '/login', :login => 'fanel', :password => 'pitulice'

    get '/admin'
    assert_equal 200, last_response.status

    get '/admin/posts'
    assert_equal 200, last_response.status

    post '/admin/posts', { :post => { :title => 'foo' }}
    assert_equal 302, last_response.status

    get "/admin/posts/#{@post.id}"
    assert_equal 200, last_response.status

    get "/admin/posts/#{@post.id}/edit"
    assert_equal 200, last_response.status

    post "/admin/posts/#{@post.id}", { :post => { :title => 'foo' }}
    assert_equal 302, last_response.status
  end

end
