class ApplicationController < ActionController::Base
  rescue_from Errno::ENOENT, with: :no_document
  rescue_from Errno::ENOENT, with: :no_document
  protect_from_forgery with: :exception

  http_basic_authenticate_with name: ENV['USERNAME'], password: ENV['PASSWORD'], if: :requires_authentication?

  def not_found
    redirect = Redirector.find(request)
    if redirect
      redirect_to redirect
    else
      render 'static/404', status: :not_found
    end
  end

  private

  def requires_authentication?
    ENV['USERNAME'] && ENV['PASSWORD']
  end

  def no_document
    not_found
  end
end
