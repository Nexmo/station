class ApplicationController < ActionController::Base
  rescue_from Errno::ENOENT, with: :no_document
  rescue_from Errno::ENOENT, with: :no_document
  protect_from_forgery with: :exception

  http_basic_authenticate_with name: ENV['USERNAME'], password: ENV['PASSWORD'], if: :requires_authentication?

  force_ssl if: :ssl_configured?
  before_action :set_show_feedback

  def not_found
    redirect = Redirector.find(request)
    if redirect
      redirect_to redirect
    else
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

  def ssl_configured?
    !Rails.env.development?
  end
end
