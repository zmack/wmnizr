class Site
  include DataMapper::Resource

  property :id, Serial
  property :hostname, String
  property :title, String
  property :slug, String
end
