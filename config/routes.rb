Rails.application.routes.draw do

  namespace :admin do
    get 'dashboard' => 'dashboard#index'
    resources :users
  end

  resources :questions do
    resources :answers
  end

  resources :comments, only: [:edit, :create, :update, :destroy]

  get '/upvote' => 'vote#upvote'
  get '/downvote' => 'vote#downvote'
  get '/accepted' => 'vote#accepted'

  resources :profiles, only: [:show, :edit, :update]

  get '/pages/tags' => 'pages#tags'
  get '/pages/rules' => 'pages#rules'
  get '/users' => 'pages#users'

  devise_for :users, path_names: { sign_up: 'register' },
             controllers: {  omniauth_callbacks:  'users/omniauth_callbacks',
                             sessions:            'sessions',
                             registrations:       'registrations',
                             passwords:           'passwords'
             }

  root 'questions#index'
  get '/all_tags' => 'home#all_tags'

  resources :home do
    collection do
      post :local_switcher
    end
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
