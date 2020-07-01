class PageTitle
  def initialize(product, document_title)
    @product        = product
    @document_title = document_title
  end

  def title
    if @product && @document_title
      "#{@product.titleize} > #{@document_title}"
    elsif @document_title
      "#{@document_title}"
    else
      'Vonage'
    end
  end
end
