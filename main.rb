require 'bootstrap'

get '/' do
  @foo = "Hello"
  haml :index
end
