module Feedback
  class FeedbacksController < ApplicationController
    def new
    end

    def create
      @feedback = ::Feedback::Feedback.find_by_id(params['feedback_feedback']['id'])
      @feedback ||= ::Feedback::Feedback.new

      @feedback.assign_attributes(feedback_params)
      @feedback.ip = request.remote_ip

      @feedback.owner = owner
      set_email
      @feedback.owner.save!
      set_cookies

      if @feedback.changed? && @feedback.save
        respond_to do |format|
          format.js
        end
      else
        head 422
      end
    end

    private

    def set_cookies
      return unless @feedback.owner.class == ::Feedback::Author
      cookies[:feedback_author_id] = {
        value: @feedback.owner.id,
        expires: 20.years.from_now,
      }
    end

    def feedback_params
      params.require(:feedback_feedback).permit(:sentiment, :comment, :source)
    end

    def owner
      return current_user if current_user
      ::Feedback::Author.find_by_id(cookies[:feedback_author_id]) ||
      ::Feedback::Author.find_by_email(params['feedback_feedback']['email']) ||
      ::Feedback::Author.new
    end

    def set_email
      return if @feedback.owner.class == User
      return if params['feedback_feedback']['email'].blank?
      @feedback.owner.email = params['feedback_feedback']['email']
    end
  end
end
