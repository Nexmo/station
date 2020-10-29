module Feedback
  class Config < ApplicationRecord
    has_many :feedbacks, inverse_of: :config

    def self.find_or_create_config(config)
      last_config = self.last
      if last_config && last_config.attributes.slice('title', 'paths') == config
        return last_config
      end

      new_config = new(title: config['title'], paths: config['paths'])
      new_config.save
      new_config
    end
  end
end
