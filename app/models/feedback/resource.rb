module Feedback
  class Resource < ApplicationRecord
    has_many :feedbacks, dependent: :destroy

    validates :uri, presence: true, allow_blank: false

    def score
      if feedbacks.any?
        ((feedbacks.positive.count.to_f / feedbacks.count.to_f) * 100.to_f).round(1)
      else
        'n/a'
      end
    end
  end
end
