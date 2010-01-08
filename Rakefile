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

desc "Remove all posts" 
task :wipe_posts do
  Post.all.destroy
end
