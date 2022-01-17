class Blog::MainController < ApplicationController
  before_action :add_gradient_bg

  private

  def add_gradient_bg
    @gradient_bg = true
  end
end
