return unless ENV['DOCS_BASE_PATH']

Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :users, ActiveAdmin::Devise.config

  namespace :feedback do
    resources :feedbacks
  end

  namespace :usage do
    resources :code_snippet
    resources :ab_result, only: [:create]
  end

  namespace :admin_api, defaults: { format: 'json' } do
    resources :feedback, only: [:index]
    resources :code_snippets, only: [:index]
  end

  get '/robots.txt', to: 'static#robots'

  get '/*landing_page', to: 'static#default_landing', constraints: LandingPageConstraint.matches?, as: :static

  get 'markdown/show'

  get '/signout', to: 'sessions#destroy'
  put '(/:locale)/set_user_locale', to: 'sessions#set_user_locale', as: :set_user_locale, constraints: LocaleConstraint.new

  post '/jobs/code_example_push', to: 'jobs#code_example_push'
  post '/jobs/open_pull_request', to: 'jobs#open_pull_request'

  get '/coverage', to: 'dashboard#coverage'
  get '/stats', to: 'dashboard#stats'
  get '/stats/summary', to: 'dashboard#stats_summary'

  get '/use-cases/(:code_language)', to: 'use_case#index', constraints: Nexmo::Markdown::CodeLanguage.route_constraint, as: :use_cases
  get '/use-cases/*document(/:code_language)', to: 'use_case#show', constraints: Nexmo::Markdown::CodeLanguage.route_constraint

  get '/*product/use-cases(/:code_language)', to: 'use_case#index', constraints: DocumentationConstraint.documentation

  get '/*product/use-cases(/:code_language)', to: 'use_case#index', constraints: lambda { |request|
    products = Product.all.map { |p| p['path'] }

    # If there's no language in the URL it's an implicit match
    includes_language = true

    # If there's a language in the URL, match on that too
    if request['code_language']
      language = Nexmo::Markdown::CodeLanguage.linkable.map(&:key).map(&:downcase)
      includes_language = language.include?(request['code_language'])
    end

    products.include?(request['product']) && includes_language
  }

  get '(/:locale)/documentation', to: 'static#documentation', constraints: LocaleConstraint.new, as: :documentation

  post '/spotlight', to: 'static#spotlight'

  get '/community/slack', to: 'slack#join'
  post '/community/slack', to: 'slack#invite'

  get '/community/past-events', to: 'static#past_events'

  get '/feeds/events', to: 'feeds#events'

  get '/extend', to: 'extend#index', as: :extend
  get '/extend/:title', to: 'extend#show'

  get '/event_search', to: 'static#event_search'
  match '/search', to: 'search#results', via: %i[get post]

  get '/api-errors', to: 'api_errors#index'
  get '/api-errors/generic/:id', to: 'api_errors#show'
  get '/api-errors/:definition(/*subapi)', to: 'api_errors#index_scoped', as: 'api_errors_scoped', constraints: OpenApiConstraint.errors_available
  get '/api-errors/*definition/:id', to: 'api_errors#show', constraints: OpenApiConstraint.errors_available

  mount ::Nexmo::OAS::Renderer::API, at: '/api'

  authenticated(:user) do
    mount Split::Dashboard, at: 'split' if ENV['REDIS_URL']
  end

  resources :careers, only: [:index]

  get '/task/(*tutorial_step)', to: 'tutorial#single'
  get '(/:locale)/(*product)/tutorials(/:code_language)', to: 'tutorial#list', constraints: DocumentationConstraint.documentation.merge(namespace: Nexmo::Markdown::CodeLanguage.route_constraint, locale: LocaleConstraint.available_locales)
  get '(/:locale)/(*product)/tutorials/(:tutorial_name)(/*tutorial_step)(/:code_language)', to: 'tutorial#index', constraints: DocumentationConstraint.documentation, locale: LocaleConstraint.available_locales
  get '(/:locale)/tutorials/(:tutorial_name)(/*tutorial_step)(/:code_language)', to: 'tutorial#index', constraints: Nexmo::Markdown::CodeLanguage.route_constraint, locale: LocaleConstraint.available_locales

  scope '(/:locale)', constraints: LocaleConstraint.new do
    get '/*product/api-reference', to: 'markdown#api'
  end

  get '(/:locale)/:namespace/*document', to: 'markdown#show', constraints: { namespace: 'product-lifecycle', locale: LocaleConstraint.available_locales }, as: 'product_lifecycle'

  get '(/:locale)/:namespace/*document(/:code_language)', to: 'markdown#show', constraints: DocumentationConstraint.documentation.merge(namespace: 'contribute', locale: LocaleConstraint.available_locales)

  get '(/:locale)/*product/*document(/:code_language)', to: 'markdown#show', constraints: DocumentationConstraint.documentation.merge(locale: LocaleConstraint.available_locales)

  get '/ed', to: 'static#blog_cookie'

  get '*unmatched_route', to: 'application#not_found'

  root 'static#landing'
end
