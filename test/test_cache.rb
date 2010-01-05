require File.expand_path(File.join(File.dirname(__FILE__), "test_bootstrap.rb"))
require 'fakefs'

class CacheTester
  include Cache

  def initialize
    @request = Struct.new(:path_info).new('foo/bar')
    @hostname = "pickle"
  end

  def path_info=(value)
    @request.path_info = value
  end
end

class CacheTest < Test::Unit::TestCase
  def setup
    @cache = CacheTester.new
    FakeFS.activate!
  end

  def teardown
    FakeFS.deactivate!
  end

  def test_creates_cache_folder_when_it_does_not_exist
    @cache.cache('foobarbaz')
    assert File.exist?('cache/pickle')
  end

  def test_creates_cache_file
    @cache.cache('foobarbaz')
    assert File.exist?('cache/pickle/foo/bar')
  end

  def test_file_created_contains_the_same_text_as_original_content
    @cache.cache('foobarbaz')
    assert_equal 'foobarbaz', File.read('cache/pickle/foo/bar')
  end

  def test_a_path_with_dots_and_shit_in_it_doesnt_screw_up_the_party_for_everyone_else
    @cache.path_info = 'foo/../../../baz'

    assert_raise(Cache::Exceptions::ShittyPath) do
      @cache.cache('foobarbaz')
    end
  end
end
