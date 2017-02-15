Rails.application.routes.draw do
  get 'markdown/show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/:product/*document', to: 'markdown#show', constraints: DocumentationConstraint.new
  get '/api', to: 'api#show'

  get '/tools', to: 'static#tools'
  root 'static#landing'
end
