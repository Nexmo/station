class LocaleSwitcherPresenter
  LOCALES = {
    'cn' => '简体中文',
    'en' => 'English',
  }.freeze

  def initialize(request)
    @request = request
  end

  def disabled?
    @request.controller_class == ActionDispatch::Request::PASS_NOT_FOUND
  end

  def current_locale
    LOCALES[I18n.locale.to_s]
  end

  def locales
    @locales ||= LOCALES.map do |k, v|
      OpenStruct.new(data: k, value: v)
    end
  end
end
