class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  http_basic_authenticate_with name: ENV['USERNAME'], password: ENV['PASSWORD'], if: :need_authentication?

  private

  def need_authentication?
    ENV['USERNAME'] && ENV['PASSWORD']
  end
end
