class Ahoy::Visit < ApplicationRecord
  self.table_name = 'ahoy_visits'

  has_many :events, dependent: :nullify, class_name: 'Ahoy::Event'
  belongs_to :user, optional: true
end
