class ExternalLinkFilter < Banzai::Filter
  def call(input)
    @input = input

    Rails.logger.debug('WATTT')

    document.css('a').each_with_index do |link, index|
      if link['href'] && link['href'].start_with?('http')
        link['target'] = '_blank'
        if link.css('.fa-external-link').empty?
          link.add_child <<~HEREDOC
            &nbsp;<i class="fa fa-external-link"></i>
          HEREDOC
        end
      end
    end

    @document.to_html
  end

  private

  def document
    @document ||= Nokogiri::HTML::DocumentFragment.parse(@input)
  end
end
