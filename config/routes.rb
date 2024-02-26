Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]
  resources :profiles
  root "homes#index"

  resources :homes
  resources :workreports
  resources :clients
  resources :projects
  resources :email_hierarchys
  resources :holidays
  resources :attendances
  resources :check_ins

  resources :users do
    member do
      delete :soft_delete
    end
  end

  resources :projects do
    member do
      delete :soft_delete
    end
  end
   resources :clients do
    member do
      delete :soft_delete
    end
  end

resources :check_ins do
  post 'checkout', on: :collection
end

resources :check_ins do
  post :checkout, on: :collection
end






  post '/create', to: 'users#create'
  # get '/other', to: 'workreports#other', as: :workreports_other
  get '/allworkreports', to: 'workreports#allworkreports'
  get '/unauthorized', to: 'errors#unauthorized'
  get '/workreports/new', to: 'workreports#new_with_user_id', as: 'new_workreport_with_user_id'

  resources :users, only: [:index, :new, :create, :edit , :show]
end
