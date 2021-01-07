ActiveAdmin.register Ahoy::Visit do
  menu parent: 'Tracking'

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :visit_token, :visitor_token, :user_id, :ip, :user_agent, :referrer, :referring_domain, :landing_page, :browser, :os, :device_type, :country, :region, :city, :latitude, :longitude, :utm_source, :utm_medium, :utm_term, :utm_content, :utm_campaign, :app_version, :os_version, :platform, :started_at
  #
  # or
  #
  # permit_params do
  #   permitted = [:visit_token, :visitor_token, :user_id, :ip, :user_agent, :referrer, :referring_domain, :landing_page, :browser, :os, :device_type, :country, :region, :city, :latitude, :longitude, :utm_source, :utm_medium, :utm_term, :utm_content, :utm_campaign, :app_version, :os_version, :platform, :started_at]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
