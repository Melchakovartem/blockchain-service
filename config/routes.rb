Rails.application.routes.draw do
  root to: 'blocks#index'

  api_version(module: "V1", path: { value: "v1" }, defaults: { format: :json }) do
  	resources :advertisers do
  		post :create_wallet
      post :get_tokens
      post :approve_tokens
      post :create_campaign
  		patch :update_wallet
      get :get_balance
      get :show_allowance
  	end
  	resources :owners do
  		post :create_wallet
      post :get_tokens
      post :approve_tokens
  		patch :update_wallet
      get :get_balance
      get :show_allowance
  	end

    resources :campaigns do
      patch :finish
      post :send_coins
    end

    resources :owners, only: :show, param: :profile_id
    resources :advertisers, only: :show, param: :profile_id
    resources :campaigns, param: :campaign_id
  end

  resources :blocks, only: [:show, :index] do
    resources :transactions, only: :index
  end
  resources :transactions, only: :show
  resources :search, only: :index
end
