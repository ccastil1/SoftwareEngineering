Rails.application.routes.draw do
  get 'welcome/index'
  get 'welcome/show/:id', to: "welcome#show", as: :welcome_show
  root 'welcome#index'

  get 'files/:name', to: 'files#show', as: :file
  get 'files/', to: 'files#list', as: :files
  post 'files/', to: 'files#upload', as: :file_upload
  get 'files/download/:name', to: 'files#download', as: :file_download
  delete 'files/:name', to: 'files#remove', as: :filedelete
end
