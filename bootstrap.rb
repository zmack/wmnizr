require 'rubygems'
require 'sinatra'
require 'haml'

require 'dm-core'

DataMapper.setup(:default, 'sqlite3::data.sqlite')
