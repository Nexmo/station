module BlogHelper
  def reading_time_without_code_tags(content)
    regexp = Regexp.new(%r{<pre class=.*main-code(.*?)</code></pre>}m)

    "#{content.gsub(regexp, '').reading_time format: :approx} read"
  rescue StandardError
    ''
  end
end
