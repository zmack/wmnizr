require File.expand_path(File.join(File.dirname(__FILE__), '..', "test_bootstrap.rb"))

class SiteTest < WmnizrTest
  def before
    @site = Site.new(:hostname => 'localhost')
  end

  def test_should_generate_host_url
    assert_equal 'http://localhost/', @site.host_url
  end

  def test_should_add_port_to_url_when_it_is_defined
    @site.port = 81
    assert_equal 'http://localhost:81/', @site.host_url
  end

  def test_should_not_add_port_if_it_is_80
    @site.port = 80
    assert_equal 'http://localhost/', @site.host_url
  end

  def test_should_generate_atom_feed_url
    assert_equal 'http://localhost/feed/atom.xml', @site.feed_url
  end

  def test_should_generate_post_url
    @post = Post.create(:user => User.create(:login => 'gigel', :password => 'cal'), :title => 'foo bar', :published_at => DateTime.parse('2009-10-11'))

    assert_equal 'http://localhost/2009/foo-bar', @site.url_for_post(@post)
  end
  
end
