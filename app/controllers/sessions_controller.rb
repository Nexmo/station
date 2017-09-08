class SessionsController < ApplicationController
  def destroy
    logout
    cookies.delete :feedback_author_id
    redirect_back(fallback_location: root_path)
  end
end
