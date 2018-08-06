Rails.application.routes.draw do
  api_version(module: "V1", path: { value: "v1" }, defaults: { format: :json }) do
  	resource :advertisers do
  		post :create_wallet
      post :get_tokens
      post :approve_tokens
      post :create_campaign
  		patch :update_wallet
      get :get_balance
      get :get_allowance
  	end
  	resource :owners do
  		post :create_wallet
      post :get_tokens
      post :approve_tokens
  		patch :update_wallet
      get :get_balance
      get :get_allowance
  	end

    resources :owners, only: :show, param: :profile_id
    resources :advertisers, only: :show, param: :profile_id
    resources :campaigns, param: :campaign_id do
      patch :finish
    end
  end
end
