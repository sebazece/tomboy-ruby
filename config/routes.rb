Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    authenticated :user do
    end

    unauthenticated :user do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
end
