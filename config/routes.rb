Rails.application.routes.draw do
  get 'markdown/show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/:product/*document', to: 'markdown#show', constraints: DocumentationConstraint.new
  get '/api', to: 'api#index'
  get '/api/*document', to: 'api#show'

  get '/tools', to: 'static#tools'
  get '/community', to: 'static#community'

  get '/styleguide', to: 'static#styleguide'

  get '*unmatched_route', to: 'application#not_found'

  root 'static#landing'
end
