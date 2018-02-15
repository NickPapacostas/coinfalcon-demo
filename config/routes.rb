Rails.application.routes.draw do
  resources :batches, only: [:create, :multi]
  root to: "pages#index"
end
