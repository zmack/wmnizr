class User
  include DataMapper::Resource

  property :id, Serial
  property :login, String
  property :crypted_password, String
end
