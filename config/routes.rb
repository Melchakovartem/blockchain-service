Rails.application.routes.draw do
  api_version(module: "V1", path: { value: "v1" }, defaults: { format: :json }) do
  	resource :advertisers do
  		post :create_wallet
  		patch :update_wallet
  	end
  	resource :owners do
  		post :create_wallet
  		patch :update_wallet
  	end
  end
end
