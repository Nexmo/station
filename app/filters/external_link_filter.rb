class ExternalLinkFilter < Banzai::Filter
  def call(input)
    @input = input

    document.css('a').each do |link|
      if link['href'].start_with? "http"
        link['target'] = '_blank'
      end
    end

    @document.to_html
  end

  private

  def document
    @document ||= Nokogiri::HTML::DocumentFragment.parse(@input)
  end
end
