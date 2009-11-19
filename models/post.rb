require 'iconv'

class Post
  include DataMapper::Resource
  include DataMapper::Timestamp

  before :save, :fill_permalink

  property :id, Serial
  property :text, Text
  property :site, String
  property :title, String
  property :permalink, String
  property :published_at, DateTime
  
  def fill_permalink
    return if title.nil?
    self.permalink = 
      (Iconv.new('US-ASCII//TRANSLIT', 'utf-8').iconv title).gsub(/[^\w\s\-\â€”]/,'').gsub(/[^\w]|[\_]/,' ').split.join('-').downcase  
  end
end
