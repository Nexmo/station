class HeadingFilter < Banzai::Filter
  def call(input)
    @input = input
    document.css('h1,h2,h3,h4,h5,h6').each do |heading|
      heading['id'] = heading.text.parameterize
    end
    @document.to_html
  end

  private

  def document
    @document ||= Nokogiri::HTML::DocumentFragment.parse(@input)
  end
end
