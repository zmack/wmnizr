module UV_Syntax
  def self.process(text)
    content = text

    content.gsub(/(<pre[^>]*>)(.+?)(<\/pre>)/m) do |match|
      %Q{<pre class="lazy">#{highlight($2.strip)}</pre>}
    end
  end

  def self.highlight(text)
    Uv.parse(text, { :syntax => 'ruby', :style => 'lazy' })
  end
end
