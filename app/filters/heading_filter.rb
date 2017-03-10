class HeadingFilter < Banzai::Filter
  def call(input)
    @input = input
    @headings = []

    document.css('h1,h2,h3,h4,h5,h6').each do |heading|
      heading['id'] = parameterized_heading_without_collision(heading)
      heading['data-id'] = SecureRandom.hex
    end
    @document.to_html
  end

  private

  def document
    @document ||= Nokogiri::HTML::DocumentFragment.parse(@input)
  end

  def parameterized_heading_without_collision(heading)
    parameterized_heading = nil
    index = nil

    loop do
      if index
        parameterized_heading = "#{heading.text.parameterize}-#{index}"
        index = index + 1
      else
        parameterized_heading = heading.text.parameterize
        index = 2
      end

      break if @headings.exclude? parameterized_heading
    end

    @headings << parameterized_heading
    parameterized_heading
  end
end
