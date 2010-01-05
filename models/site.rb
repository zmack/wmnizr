class Site
  include DataMapper::Resource

  property :id, Serial
  property :hostname, String
  property :title, String
  property :slug, String

  def host_url
    "http://#{hostname}/"
  end

  def feed_url
    "#{host_url}/feed/atom.xml"
  end

  def url_for_article(article)
    "#{host_url}/#{article.perma_path}"
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
          entry.id self.url_for_article(item)
          entry.author do |author|
            author.name item.user.login
            author.uri self.host_url
          end
          entry.title item.title
          entry.link(:rel => "alternate", :type => 'text/html', :href => self.url_for_article(item))
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
