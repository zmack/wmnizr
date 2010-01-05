module Cache
  module Exceptions
    class ShittyPath < Exception; end
  end

  def cache(content)
    cache_to_file(content)

    content
  end

  def cache_path
    path = File.join(cache_dir, @request.path_info)
    path << 'index.html' if path[-1..-1] == '/'

    path
  end

  def cache_dir
    File.join(BASE_PATH, 'cache', @hostname)
  end

  def cache_to_file(content)
    create_dirs

    File.open(cache_path, 'w') do |file|
      file << content
    end
  end

  def create_dirs
    FileUtils.mkdir_p cache_dir unless File.exist? cache_dir
    cache_path_dir = File.dirname(cache_path)

    if File.expand_path(cache_path_dir).index(File.expand_path(cache_dir)) != 0
      raise Exceptions::ShittyPath
    end
    
    FileUtils.mkdir_p cache_path_dir unless File.exist? cache_path_dir
  end
end
