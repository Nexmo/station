class StaticController < ApplicationController
  def landing
    @navigation = :documentation
    render layout: 'landing'
  end

  def tools
    @navigation = :tools
  end

  def community
    @navigation = :community
    @upcoming_events = Event.upcoming
  end
end
