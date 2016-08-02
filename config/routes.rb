Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  # ActiveAdmin.routes(self)

  get 'home', to: redirect('/')

  devise_for :user, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  devise_scope :user do
    get 'edit', to: 'users/registrations#edit'
    match 'user/sign_out' => 'users/sessions#destroy', via: [:get, :delete]
  end
end
