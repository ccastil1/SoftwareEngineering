Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'

  get 'files/:name', to: 'files#show', as: :file
  get 'files/', to: 'files#list', as: :files
end