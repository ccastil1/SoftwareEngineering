Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'

  get 'files/:id', to: 'files#show', as: :file
end
