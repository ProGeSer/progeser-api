Rails.application.routes.draw do
  scope :api do
    scope :v1 do
      use_doorkeeper
    end
  end

  namespace :api do
    namespace :v1 do
      resource :me, controller: 'me', only: %i[show update destroy]

      resources :invites, only: %i[create destroy] do
        post :retry, on: :member
      end

      post '/users/:invitation_token/create_from_invite', to: 'users#create_from_invite'
    end
  end
end
