class PageTitle
  CONFIG = YAML.safe_load(File.open("#{Rails.configuration.docs_base_path}/config/header_meta.yml"))

  def initialize(product, document_title)
    @product        = product
    @document_title = document_title
  end

  def title
    if @product && @document_title
      "#{@product.titleize} > #{@document_title} | #{default_title}"
    elsif @document_title
      "#{@document_title} | #{default_title}"
    else
      default_title
    end
  end

  def default_title
    config = YAML.safe_load(File.open("#{Rails.configuration.docs_base_path}/config/header_meta.yml"))
    config['title']
  end
end
