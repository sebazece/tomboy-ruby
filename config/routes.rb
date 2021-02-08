Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    authenticated :user do
      root 'backend/home#index'
    end

    unauthenticated :user do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  namespace :backend do
    resources :books, :notes
    get 'note/:id', to: 'exports#note', as: :exports_note
    get 'book/:id', to: 'exports#book', as: :exports_book
    get 'all', to: 'exports#all', as: :exports_all
  end
end
