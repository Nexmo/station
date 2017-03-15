Rails.application.routes.draw do
  get 'markdown/show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/:product/*document', to: 'markdown#show', constraints: DocumentationConstraint.new

  get '/api', to: 'api#index'
  get '/api/*document', to: 'api#show'

  get '/tutorials', to: 'tutorials#index'
  get '/tutorials/*document', to: 'tutorials#show'

  get '/tools', to: 'static#tools'
  get '/community', to: 'static#community'

  get '/styleguide', to: 'static#styleguide'
  get '/write-the-docs', to: 'static#write_the_docs'

  match '/search', to: 'search#results', via: [:get, :post]
  match '/quicksearch', to: 'search#quicksearch', via: [:get, :post]

  get '*unmatched_route', to: 'application#not_found'

  root 'static#landing'
end
