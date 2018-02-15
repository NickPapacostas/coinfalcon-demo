Rails.application.routes.draw do
  resources :batches, only: [:create, :multi] do
    get '/batches/multi', to: "batches#multi"
  end

  root to: "pages#index"
end
