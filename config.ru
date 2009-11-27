require 'bootstrap.rb'
require 'wmnizr.rb'

use Rack::Session::Cookie

use Warden::Manager do |manager|
  manager.default_strategies :password, :pickle
  manager.failure_app = Wmnizr
end

run Wmnizr
