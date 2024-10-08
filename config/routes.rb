Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'recipes/index', to: 'recipes#index'
      get '/show/:id', to: 'recipes#show'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'home#index'

  # Defines the catch-all route, which is used for client-side routing.
  get '/*path' => 'home#index'
end
