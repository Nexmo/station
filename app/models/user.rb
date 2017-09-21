class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :feedbacks, as: :owner, class_name: 'Feedback::Feedback'
end
