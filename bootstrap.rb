require 'rubygems'
require 'sinatra'
require 'haml'

require 'dm-core'

Dir.glob('models/*.rb') { |x| require x }

BASE_PATH =  File.expand_path(File.dirname(__FILE__))

DataMapper.setup :default, "sqlite3:#{File.join(BASE_PATH, 'data.sqlite')}"
