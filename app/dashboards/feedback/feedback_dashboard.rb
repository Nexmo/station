require 'administrate/base_dashboard'

module Feedback
  class FeedbackDashboard < Administrate::BaseDashboard
    # ATTRIBUTE_TYPES
    # a hash that describes the type of each of the model's fields.
    #
    # Each different type represents an Administrate::Field object,
    # which determines how the attribute is displayed
    # on pages throughout the dashboard.
    ATTRIBUTE_TYPES = {
      id: Field::String.with_options(searchable: false),
      user: Field::BelongsTo,
      resource: Field::BelongsTo.with_options(class_name: '::Feedback::Resource'),
      sentiment: Field::String,
      ip: Field::String,
      comment: Field::Text,
      created_at: Field::DateTime,
      updated_at: Field::DateTime,
    }.freeze

    # COLLECTION_ATTRIBUTES
    # an array of attributes that will be displayed on the model's index page.
    #
    # By default, it's limited to four items to reduce clutter on index pages.
    # Feel free to add, remove, or rearrange items.
    COLLECTION_ATTRIBUTES = [
      :id,
      :user,
      :resource,
      :sentiment,
      :ip,
      :comment,
      :created_at,
    ].freeze

    # SHOW_PAGE_ATTRIBUTES
    # an array of attributes that will be displayed on the model's show page.
    SHOW_PAGE_ATTRIBUTES = [
      :id,
      :user,
      :resource,
      :sentiment,
      :ip,
      :comment,
      :created_at,
      :updated_at,
    ].freeze

    # FORM_ATTRIBUTES
    # an array of attributes that will be displayed
    # on the model's form (`new` and `edit`) pages.
    FORM_ATTRIBUTES = [
      :user,
      :resource,
      :sentiment,
      :ip,
      :comment,
    ].freeze

    # Overwrite this method to customize how resources are displayed
    # across all pages of the admin dashboard.
    #
    # def display_resource(resource)
    #   "Feedback::Resource ##{resource.id}"
    # end
  end
end
