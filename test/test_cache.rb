require File.expand_path(File.join(File.dirname(__FILE__), "test_bootstrap.rb"))
require 'fakefs'

class CacheTester
  include Cache

  def initialize
    @request = Struct.new(:path_info).new('foo')
    @hostname = "pickle"
  end
end

class CacheTest < Test::Unit::TestCase
  def setup
    @cache = CacheTester.new
    FakeFS.activate!
    @cache.cache('foobarbaz')
  end

  def teardown
    FakeFS.deactivate!
  end

  def test_creates_cache_folder_when_it_does_not_exist
    assert File.exist?('cache/pickle')
  end

  def test_creates_cache_file
    assert File.exist?('cache/pickle/foo')
  end

  def test_file_created_contains_the_same_text_as_original_content
    assert_equal 'foobarbaz', File.read('cache/pickle/foo')
  end
end
