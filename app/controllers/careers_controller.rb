class CareersController < ApplicationController
  def show
    @career = Career.visible_to(current_user).friendly.find(params[:id])
  end
end
