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

  def self.published
    self.all(:conditions => ["published_at is not null"])
  end

  def self.by_year(year)
    self.all(:conditions => ["strftime('%Y', published_at) = '#{year.to_i}'"])
  end
  
  def fill_permalink
    return if title.nil?
    self.permalink = 
      (Iconv.new('US-ASCII//TRANSLIT', 'utf-8').iconv title).gsub(/[^\w\s\-\â€”]/,'').gsub(/[^\w]|[\_]/,' ').split.join('-').downcase  
  end


  def published?
    !self.published_at.nil?
  end

  def published=(value)
    self.published_at = Time.now if value
  end
end