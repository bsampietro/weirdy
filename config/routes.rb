Weirdy::Engine.routes.draw do
  root :to => 'wexceptions#index'
  resources :wexceptions, only: [:index, :destroy] do
  	resources :wexception_occurrences, only: :index
    member do
      put 'state'
    end
  end
end
