ActiveAdmin.register Ahoy::Event do
  menu parent: 'Tracking'

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :visit_id, :user_id, :name, :properties, :time
  #
  # or
  #
  # permit_params do
  #   permitted = [:visit_id, :user_id, :name, :properties, :time]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
