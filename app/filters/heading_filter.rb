class HeadingFilter < Banzai::Filter
  def call(input)
    @input = input
    document.css('h1,h2,h3,h4,h5,h6').each do |heading|
      # parameterize is part of ActiveSupport::Inflector
      # See https://goo.gl/HyZ1L8 for alternative if you do not
      # have this module available.
      heading['id'] = heading.text.parameterize
    end
    @document.to_html
  end

  private

  def document
    @document ||= Nokogiri::HTML::DocumentFragment.parse(@input)
  end
end
