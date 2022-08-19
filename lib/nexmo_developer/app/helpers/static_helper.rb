module StaticHelper
  # this is to refactor_keys in landing_page_documentation.html.erb
  def refactor_keys(resource)
    resource.keys.first.to_s.gsub(' ', '-')
  end

  def refactor_class
    'Vlt-btn Vlt-btn--blue Vlt-btn--app Vlt-btn--small'
  end

  def first(resource)
    resource.keys.first
  end
end