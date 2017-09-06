module Feedback
  class FeedbacksController < ApplicationController
    def new
    end

    def create
      @feedback = ::Feedback::Feedback.find_by_id(params['feedback_feedback']['id'])
      @feedback ||= ::Feedback::Feedback.new

      @feedback.assign_attributes(feedback_params)
      @feedback.ip = request.remote_ip

      @feedback.user = current_user
      @feedback.user ||= User.new

      if params['feedback_feedback']['email'].present?
        if current_user.email
          @feedback.user = User.new if params['feedback_feedback']['email'] != current_user.email
        end

        @feedback.user.email = params['feedback_feedback']['email']
      end

      @feedback.user.save!

      auto_login(@feedback.user, true)

      if @feedback.changed? && @feedback.save
        respond_to do |format|
          format.js
        end
      else
        head 422
      end
    end

    private

    def feedback_params
      params.require(:feedback_feedback).permit(:sentiment, :comment, :source)
    end
  end
end
