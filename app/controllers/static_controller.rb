class StaticController < ApplicationController
  def landing
    @navigation = :documentation
    render layout: 'landing'
  end

  def tools
    @navigation = :tools
  end
end
