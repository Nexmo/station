module Feedback
  class Resource < ApplicationRecord
    has_many :feedbacks, dependent: :destroy

    validates :uri, presence: true, allow_blank: false

    def display_name
      uri
    end

    def score
      if feedbacks.any?
        score_value.round(1)
      else
        'n/a'
      end
    end

    def score_value
      ((feedbacks.positive.count.to_f / feedbacks.count.to_f) * 100.to_f)
    end

    def relative_link
      URI(uri).path
    end

    def self.worst_performing
      all.select { |resource| resource.feedbacks.count > 5 }.sort_by(&:score_value)
    end

    def self.best_performing
      worst_performing.reverse
    end
  end
end
