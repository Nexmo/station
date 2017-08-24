class EventsController < ApplicationController
  def index
    calendar = Icalendar::Calendar.new

    Event.all.each do |event|
      calendar.event do |e|
        e.dtstart = event.starts_at
        e.dtend = event.ends_at
        e.summary = event.title
        e.description = event.description
      end
    end

    calendar.publish
    send_data calendar.to_ical, type: :ics
  end
end
