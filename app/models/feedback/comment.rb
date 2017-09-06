module Feedback
  class Comment < ActiveRecord::Base
    acts_as_nested_set scope: [:commentable_id, :commentable_type]

    validates :body, presence: true
    validates :user, presence: true

    belongs_to :commentable, polymorphic: true
    belongs_to :user

    def self.build_from(object, user_id, comment)
      new(
        commentable: object,
        body: comment,
        user_id: user_id
      )
    end

    def has_children?
      children.any?
    end

    scope :find_comments_by_user, lambda do |user|
      where(user: user).order('created_at DESC')
    end

    scope :find_comments_for_commentable, lambda do |commentable_str, commentable_id|
      where(commentable_type: commentable_str.to_s, commentable_id: commentable_id).order('created_at DESC')
    end

    def self.find_commentable(commentable_str, commentable_id)
      commentable_str.constantize.find(commentable_id)
    end
  end
end
