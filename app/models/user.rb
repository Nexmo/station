class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :feedbacks, as: :owner
end
