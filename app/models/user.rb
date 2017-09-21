class User < ApplicationRecord
  has_many :feedbacks, as: :owner, class_name: 'Feedback::Feedback'
end
