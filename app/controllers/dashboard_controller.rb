class DashboardController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_additional_scripts

  def stats
    @total_feedbacks_count = Feedback::Feedback.count
    @positive_feedbacks = Feedback::Feedback.positive.all
    @negative_feedbacks = Feedback::Feedback.negative.all
  end

  private

  def set_additional_scripts
    @additional_scripts = ['stats']
  end
end
