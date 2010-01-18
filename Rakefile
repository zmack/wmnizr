require 'bootstrap.rb'

desc "Migrate the mappers"
task :migrate do
  DataMapper.auto_migrate!
end

desc "Import from mephisto dump"
task :import do
  require 'mysql'

  db = Mysql.new 'localhost', 'root', '', 'blogs'
  user = User.first

  articles = db.query(<<-QUERY)
  select contents.title, contents.body, sites.host as host, contents.created_at
    from contents left join sites on site_id = sites.id where contents.type="Article"
    order by created_at
  QUERY

  articles.each do |article|
    Post.create(:title => article[0], :text => article[1], :site => article[2], :published_at => article[3], :user => user)
  end
end

desc "Migrate all shitty pre's to manly code tags"
task :pre_to_code do
  Post.all.each do |post|
    doc = Nokogiri::HTML.parse(post.text)
    doc.css('pre[name=code]').each do |pre|
      code = Nokogiri::XML::Node.new('code', doc)
      code.inner_html = pre.inner_html
      code.set_attribute('class', 'ruby')
      pre.replace(code)
    end

    post.text = doc.css('body').inner_html
    post.save!
  end
end

desc "Add lang to all pre's"
task :add_lang_to_pre do
  Post.all.each do |post|
    doc = Nokogiri::HTML.parse(post.text)
    doc.css('pre[name=code]').each do |pre|
      pre.remove_attribute('name')
      pre.set_attribute('class', 'code')
      pre.set_attribute('lang', 'ruby')
    end

    post.text = doc.css('body').inner_html
    post.save!
  end
end

desc "Remove all posts" 
task :wipe_posts do
  Post.all.destroy
end
