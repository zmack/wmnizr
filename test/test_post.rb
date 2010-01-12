require File.expand_path(File.join(File.dirname(__FILE__), '..', "test_bootstrap.rb"))


class PostTest < WmnizrTest
  def before
    @user = User.new(:login => 'test', :password => 'test')
  end

  def test_fill_permalink
    @post = Post.create(:title => 'foo bar', :user => @user)
    assert_equal 'foo-bar', @post.permalink
  end

  def test_generate_perma_path
    @post = Post.create(:title => 'foo bar', :user => @user, :published_at => DateTime.parse('2009-10-11'))
    assert_equal '2009/foo-bar', @post.perma_path
  end

  def test_dont_die_on_nil_title
    @post = Post.new

    assert_nothing_raised do
      @post.save
    end
  end

  def test_permalink_unicode_chars
    @post = Post.new :title => "fånç¥ ƒootwørk", :user => @user
    @post.save

    assert_equal 'fancyen-footwork', @post.permalink
  end

  def test_fill_published_at_on_attributing_published
    @post = Post.new :title => "foo bar", :published => true, :user => @user

    assert_not_equal nil, @post.published_at 
  end

  def test_dont_fill_published_at_on_attributing_published_as_false
    @post = Post.new :title => "foo bar", :published => false, :user => @user

    assert_equal nil, @post.published_at 
  end

  def test_set_published_at_to_nil_if_published_is_set_to_false
    @post = Post.new :title => "foo bar", :published => true, :user => @user

    assert_not_equal nil, @post.published_at 

    @post.published = false
    assert_equal nil, @post.published_at 
  end

  def test_dont_use_published_as_a_fucking_toggle
    @post = Post.new :title => "foo bar", :published => true, :user => @user

    @post.published = true
    assert @post.published?
    
    @post.published = true
    assert @post.published?
  end

  def test_return_published_posts
    @post = Post.create :title => 'foo', :published => true, :user => @user
    @post = Post.create :title => 'foo', :published => false, :user => @user

    assert_equal 1, Post.published.count
  end

  def test_return_published_posts_by_year
    @post = Post.create :title => 'foo', :published_at => Date.parse('11-11-2005'), :user => @user
    @post = Post.create :title => 'foo', :published => true, :user => @user

    assert_equal 1, Post.by_year(2005).count
    assert_equal 1, Post.by_year(Time.now.year).count
  end
end
