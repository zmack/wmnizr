require File.expand_path(File.join(File.dirname(__FILE__), "test_bootstrap.rb"))


class PostTest < WmnizrTest
  def test_fill_permalink
    @post = Post.create(:title => 'foo bar')
    assert_equal 'foo-bar', @post.permalink
  end

  def test_dont_die_on_nil_title
    @post = Post.new

    assert_nothing_raised do
      @post.save
    end
  end

  def test_permalink_unicode_chars
    @post = Post.new :title => "fånç¥ ƒootwørk"
    @post.save

    assert_equal 'fancyen-footwork', @post.permalink
  end
end
