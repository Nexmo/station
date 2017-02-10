class StaticController < ApplicationController
  def landing
    @navigation = :documentation
    render layout: 'landing'
  end
end
