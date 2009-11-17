require 'bootstrap.rb'
require 'sinatra'

get '/admin' do
  p request["SERVER_NAME"]
  @foo = "Hello"
  haml :index
end
