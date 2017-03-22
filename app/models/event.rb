class Event < ApplicationRecord
  default_scope -> { order(:starts_at) }
  scope :upcoming, -> { where('starts_at > ?', Date.today) }

  def date_range
    starts = starts_at.strftime('%d %B %Y')
    ends = ends_at.strftime('%d %B %Y')
    if starts_at == ends_at
      return starts
    else
      return "#{starts} - #{ends}"
    end
  end
end
