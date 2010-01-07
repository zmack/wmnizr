class Site
  include DataMapper::Resource

  property :id, Serial
  property :hostname, String
  property :title, String
  property :slug, String
  property :port, Integer

  def host_url
    return @host_url unless @host_url.nil?

    if self.port == 80 || port.nil?
      @host_url = "http://#{hostname}/"
    else 
      @host_url = "http://#{hostname}:#{port}/"
    end
  end

  def feed_url
    "#{host_url}feed/atom.xml"
  end

  def url_for_post(post)
    "#{host_url}#{post.perma_path}"
  end

  def atom_feed_from(items)
    builder = Builder::XmlMarkup.new

    builder.feed(:xmlns => "http://www.w3.org/2005/Atom") do |feed|
      feed.title(self.title, :type => "text")
      feed.subtitle(self.slug, :type => "html")
      feed.id(self.host_url)

      feed.updated items.first.updated_at.to_time.iso8601

      feed.link(:rel => "alternate", :type => "text/html", :href => self.host_url)
      feed.link(:rel => "self", :type => "application/atom+xml", :href => self.feed_url)

      items.each do |item|
        feed.entry do |entry|
          entry.id self.url_for_post(item)
          entry.author do |author|
            author.name item.user.login
            author.uri self.host_url
          end
          entry.title item.title
          entry.link(:rel => "alternate", :type => 'text/html', :href => self.url_for_post(item))
          entry.updated item.updated_at.to_time.iso8601
          entry.published item.published_at.to_time.iso8601
          entry.content(:type => 'xhtml') do |content|
            content.div(item.text, :xmlns => "http://www.w3.org/1999/xhtml")
          end
        end
      end
      
    end

  end
end
