Rails.application.routes.draw do
  get 'reports', to: 'reports#index'

  constraints(hostname: /[A-Za-z0-9\-\.]+/) do
    put 'reports/:hostname/:key', to: 'reports#update', as: 'report'
    delete 'reports/:hostname/:key', to: 'reports#destroy'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
