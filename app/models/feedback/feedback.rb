module Feedback
  class Feedback < ApplicationRecord
    acts_as_commentable

    belongs_to :resource
    belongs_to :user

    attr_accessor :email, :source
    before_validation :set_resource

    validates :sentiment, presence: true
    validates :user, presence: true

    default_scope -> { order(created_at: :desc) }

    scope :positive, -> { where(sentiment: 'positive') }
    scope :negative, -> { where(sentiment: 'negative') }

    after_commit :notify

    private

    def emoji
      case sentiment
      when 'negative' then '👎'
      when 'neutral' then '😐'
      when 'positive' then '👍'
      else '😕'
      end
    end

    def set_resource
      self.resource ||= Resource.find_or_create_by!(uri: source)
    end

    def notify
      notify_slack
    end

    def notify_slack
      return unless ENV['SLACK_WEBHOOK']

      message = []
      state = (created_at == updated_at ? 'New' : 'Updated')
      message << "#{state} #{sentiment} feedback #{emoji} for #{resource.uri}"
      message << '💬 with comment' if comment.present?
      message << "<a href='#{ENV['PROTOCOL']}://#{ENV['HOST']}/admin/feedbacks/#{id}'>Read more</a>"

      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK'], username: 'feedbot'
      message = Slack::Notifier::Util::LinkFormatter.format(message.join(' • '))
      notifier.ping message
    end
  end
end
