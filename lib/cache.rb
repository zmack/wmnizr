module Cache
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
    FileUtils.mkdir_p cache_dir unless File.exist? cache_dir

    File.open(cache_path, 'w') do |file|
      file << content
    end
  end
end
