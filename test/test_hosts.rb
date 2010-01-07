require File.expand_path(File.join(File.dirname(__FILE__), '..', "test_bootstrap.rb"))
require File.expand_path(File.join(File.dirname(__FILE__), '..', "wmnizr.rb"))

class TestHosts < WmnizrTest
  include Rack::Test::Methods

  def app
    ::Wmnizr
  end

  def before
    @post = Post.create
  end

  def test_stuff_happens
    get '/', {}, { 'SERVER_NAME' => 'localhost' }
  end

end
