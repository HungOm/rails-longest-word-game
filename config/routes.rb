Rails.application.routes.draw do
  get '/new', to: 'games#new'
  post '/score', to: 'games#score'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
