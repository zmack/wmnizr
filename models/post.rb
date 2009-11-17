class Post
  include DataMapper::Resource

  property :id, Serial
  property :title, String
  property :site_id, Serial
  property :text, Text
end
