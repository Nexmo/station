module Feedback
  class Config < ApplicationRecord
    has_many :feedbacks, inverse_of: :config

    def self.find_or_create_config(config)
      last_config = self.last
      return last_config if last_config && last_config.attributes.except('id') == config

      new_config = new(title: config['title'], paths: config['paths'])
      new_config.save
      new_config
    end
  end
end
