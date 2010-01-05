require File.expand_path(File.join(File.dirname(__FILE__), "test_bootstrap.rb"))
require 'fakefs'

class CacheTester
  include Cache

  def initialize
    @request = Struct.new(:path_info).new('foo')
  end
end

class CacheTest < Test::Unit::TestCase
  def setup
    @cache = CacheTester.new
  end

  def test_creates_cache_folder_when_it_does_not_exist
    FakeFS.activate!
    @cache.cache('foobarbaz')
    assert File.exist?('cache/foo')
    assert_equal 'foobarbaz', File.read('cache/foo')
    FakeFS.deactivate!
  end

  def test_creates_cache_file
  end

  def test_file_created_contains_the_same_text_as_original_content
  end
end
