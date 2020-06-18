module ApplicationHelper
  CONFIG = YAML.load_file("#{Rails.configuration.docs_base_path}/config/business_info.yml")

  def search_enabled?
    defined?(ALGOLIA_CONFIG) && ENV['ALGOLIA_SEARCH_KEY']
  end

  def theme
    return unless ENV['THEME']

    "theme--#{ENV['THEME']}"
  end

  def active_sidenav_item
    if params[:tutorial_name]
      url_for(controller: :tutorial, action: :index, product: params[:product], tutorial_name: params[:tutorial_name])
    else
      request.path.chomp("/#{params[:code_language]}")
    end
  end

  def canonical_path
    request.path.chomp("/#{params[:code_language]}")
  end

  def canonical_url
    return @canonical_url if @canonical_url

    canonical_path.prepend(canonical_base)
  end

  def canonical_base
    canonical_base_from_config || request.base_url
  end

  def dashboard_cookie(campaign)
    # This is the first touch time so we only want to set it if it's not already set
    set_utm_cookie('ft', Time.now.getutc.to_i) unless cookies[:ft]

    # These are the things we'll be tracking through the customer dashboard
    set_utm_cookie('utm_source', 'developer.nexmo.com')
    set_utm_cookie('utm_medium', 'referral')
    set_utm_cookie('utm_campaign', campaign)

    # We don't use term or content as it's not paid, but they may have been set by other things
    # If they were, delete them so our data isn't tainted
    cookies.delete('utm_term', domain: :all)
    cookies.delete('utm_content', domain: :all)
  end

  def set_utm_cookie(name, value)
    cookies[name] = {
      value: value,
      expires: 1.year.from_now,
      domain: :all,
    }
  end

  def canonical_base_from_config
    CONFIG['base_url']
  end
end
