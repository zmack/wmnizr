class Post
  include DataMapper::Resource
  include DataMapper::Timestamp

  property :id, Serial
  property :text, Text
  property :site, String
  property :title, String
  property :permalink, String
  property :published_at, DateTime
end
