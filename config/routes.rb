Rails.application.routes.draw do
  get 'private_controller/private'

  root 'static_pages#top'
  get '/signup', to: 'users#new'
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get    '/access', to: 'sessions#access'#アクセスページ追加
  post '/callback' => 'linebot#callback'#ラインbot
  get 'api/private' => 'private#private'
  get 'api/private-scoped' => 'private#private_scoped'

  resources :users do#resourcesの横には、コントーラ名がくる
    #post :csv_import, on: :collection
    member do
      get 'users.csv',to: 'users#csv_index'
      get 'attendances/approval_work_info'
      patch 'attendances/approval_work_info_update'
      get 'csv_index'
      get 'join'
      post'join_create'
    end
    collection do
      get :index_attendance
      get :index_rank
      post :csv_import
    end
    resources :attendances do
      member do
        get 'attendances/request_work_info'
        patch 'attendances/request_work_info_update'
        get 'confirm_approval'
        get 'download'
      end
    end
  end

  resources :posts
  
end
