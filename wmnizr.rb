require 'bootstrap.rb'
require 'sinatra'

class Wmnizr < Sinatra::Base
  get '/admin' do
    #p request["SERVER_NAME"]
    @foo = "Hello"
    haml :index
  end

  get '/:year/:permalink' do
    p params
    "Hi boi"
  end

  get '/:permalink' do
    p params
    "Hi boi"
  end
end
