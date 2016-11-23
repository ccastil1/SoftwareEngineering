Rails.application.routes.draw do
  get 'welcome/index'
  get 'welcome/show/:id', to: "welcome#show", as: :welcome_show
  root 'welcome#index'

  get 'files/:name', to: 'files#show', as: :file
  get 'files/', to: 'files#list', as: :files
  post 'files/', to: 'files#upload', as: :file_upload
  get 'files/download/:name', to: 'files#download', as: :file_download
  delete 'files/:name', to: 'files#remove', as: :filedelete

  get 'file_node_files/:name',
      to: 'file_node_files#show',
      as: :file_node_file
  get 'file_node_files/download/:name',
      to: 'file_node_files#download',
      as: :file_node_file_download
  get 'file_node_files/',
      to: 'file_node_files#list',
      as: :file_node_files
  post 'file_node_files/', to: 'file_node_files#upload', as: :file_node_upload
  delete 'file_node_files/:name', to: 'file_node_files#remove', as: :file_node_delete
end
