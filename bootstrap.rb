require 'rubygems'

require 'haml'
require 'sass'
require 'dm-core'
require 'dm-timestamps'

#Really, how the fuck would you do this another way ? =/
Dir.glob('models/*.rb') { |x| require x }

BASE_PATH = File.expand_path(File.dirname(__FILE__))

DataMapper.setup :default, "sqlite3:#{File.join(BASE_PATH, 'data.sqlite')}"
