class Sidenav
  attr_reader :request_path, :navigation, :product, :code_language, :locale

  # rubocop:disable Metrics/ParameterLists
  def initialize(request_path:, navigation:, product:, locale: nil, code_language: nil, namespace: nil)
    @request_path  = request_path
    @navigation    = navigation
    @product       = product
    @locale        = locale
    @code_language = code_language
    @namespace     = namespace

    after_initialize!
  end
  # rubocop:enable Metrics/ParameterLists

  def nav_items
    @nav_items ||= items.map do |item|
      if @request_path && @request_path.split('/')[1].include?(item[:title])
        SidenavItem.new(folder: item, sidenav: self)
      end
    end.compact

    if @nav_items.blank?
      @nav_items = items.map do |item|
        if @product && @product.split('/')[1] && @product.split('/')[1].include?(item[:title])
          SidenavItem.new(folder: item, sidenav: self)
        end
      end.compact
    end

    if @nav_items.blank?
      @nav_items = items.map do |item|
        if @product && @product.split('/')[0] && @product.split('/')[0].include?(item[:title])
          SidenavItem.new(folder: item, sidenav: self)
        end
      end.compact
    end

    if @nav_items.blank?
      @nav_items = items.map do |item|
        if @product && @product.split('/')[1].nil? && @product.include?(item[:title])
          SidenavItem.new(folder: item, sidenav: self)
        end
      end.compact
    end

    @nav_items
  end

  def namespace
    @namespace.presence || 'documentation'
  end

  def documentation?
    namespace == 'documentation'
  end

  private

  def after_initialize!
    if @namespace.present?
      @path = "app/views/#{@namespace}"
    else
      @path = "#{Rails.configuration.docs_base_path}/_documentation"
    end
  end

  def children
    @children ||= resolver.items
  end

  def items
    if @namespace.present?
      [{
        title: @namespace,
        path: @path.gsub('app/views', ''),
        children: children,
      }]
    else
      children
    end
  end

  def resolver
    @resolver ||= SidenavResolver.new(
      path: @path,
      namespace: @namespace,
      language: I18n.locale
    )
  end
end
