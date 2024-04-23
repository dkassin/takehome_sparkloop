Rails.application.routes.draw do
  resources :elements, only: [:create]
end
