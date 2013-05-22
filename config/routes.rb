Weirdy::Engine.routes.draw do
  root :to => 'wexceptions#index'
  resources :wexceptions do
    member do
      put 'state'
    end
  end
end
