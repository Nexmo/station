class FeedbackPresenter
  def initialize(params, request, session, document_path)
    @params        = params
    @request       = request
    @session       = session
    @document_path = document_path
  end

  def code_language?
    @params[:code_language].present?
  end

  def code_language
    @request.parameters['code_language']
  end

  def captcha_enabled?
    ENV['RECAPTCHA_ENABLED'] || false
  end

  def captcha_key
    ENV['RECAPTCHA_INVISIBLE_SITE_KEY']
  end

  def passed_invisible_captcha?
    @session[:user_passed_invisible_captcha] || false
  end
end
