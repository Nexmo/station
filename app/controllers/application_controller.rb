class ApplicationController < ActionController::Base
  rescue_from Errno::ENOENT, with: :no_document
  rescue_from Errno::ENOENT, with: :no_document
  protect_from_forgery with: :exception

  http_basic_authenticate_with name: ENV['USERNAME'], password: ENV['PASSWORD'], if: :requires_authentication?

  force_ssl if: :ssl_configured?
  before_action :set_show_feedback
  before_action :set_notices
  before_action :set_code_language
  before_action :set_canonical_url

  def not_found
    redirect = Redirector.find(request)
    if redirect
      redirect_to redirect
    else
      Bugsnag.notify('404 - Not Found') do |notification|
        notification.add_tab(:request, {
          params: request.params,
          path: request.path,
          base_url: request.base_url,
        })
      end
      render 'static/404', status: :not_found, formats: [:html]
    end
  end

  private

  def requires_authentication?
    ENV['USERNAME'] && ENV['PASSWORD']
  end

  def no_document
    not_found
  end

  def set_show_feedback
    @show_feedback = true
  end

  def set_code_language
    @code_language = request.params[:code_language]
  end

  def ssl_configured?
    !Rails.env.development?
  end

  def set_notices
    @notices ||= YAML.load_file("#{Rails.root}/config/notices.yml")
  end

  def set_canonical_url
    if params[:code_language]
      @canonical_url = request.path.gsub("/#{params[:code_language]}", '')
      @canonical_url.prepend(request.base_url)
    end
  end
end
