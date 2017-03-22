class Event < ApplicationRecord
  default_scope -> { order(:starts_at) }
  scope :upcoming, -> { where('starts_at > ?', Time.zone.today) }

  def date_range
    starts = starts_at.strftime('%d %B %Y')
    ends = ends_at.strftime('%d %B %Y')
    return starts if starts_at == ends_at
    "#{starts} - #{ends}"
  end
end
