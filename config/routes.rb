Rails.application.routes.draw do
  get 'top_commenters/raw_sql'
  get 'top_commenters/active_record'
  devise_for :users


  root "home#welcome"
  resources :genres, only: :index do
    member do
      get "movies"
    end
  end
  resources :movies, only: [:index, :show] do
    member do
      get :send_info
      post :add_comment
      get :remove_comment
    end

    resources :likes, only: [:create]

    collection do
      get :export
    end
  end
end
