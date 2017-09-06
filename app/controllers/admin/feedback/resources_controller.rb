module Admin
  module Feedback
    class ResourcesController < Admin::ApplicationController
      # To customize the behavior of this controller,
      # you can overwrite any of the RESTful actions. For example:
      #
      # def index
      #   super
      #   @resources = Feedback::Resource.
      #     page(params[:page]).
      #     per(10)
      # end

      # Define a custom finder by overriding the `find_resource` method:
      # def find_resource(param)
      #   Feedback::Resource.find_by!(slug: param)
      # end

      # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
      # for more information

      def resource_class
        ::Feedback::Resource
      end
    end
  end
end
