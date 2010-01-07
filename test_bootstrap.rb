require File.expand_path(File.dirname(__FILE__) + "/bootstrap.rb")
require 'test/unit'
require 'rack/test'

DataMapper.setup :default, "sqlite3::memory:"
DataMapper.auto_migrate!

class WmnizrTest < Test::Unit::TestCase
  def setup
    @transaction = DataMapper::Transaction.new(repository)
    @transaction.begin
    repository.adapter.push_transaction(@transaction)

    send(:before) if self.respond_to? :before
  end

  def teardown
    send(:after) if self.respond_to? :after

    @transaction.rollback
    repository.adapter.pop_transaction
  end

  def default_test
  end
end
