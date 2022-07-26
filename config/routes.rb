Rails.application.routes.draw do

  get 'relationships/followings'
  get 'relationships/followers'
  post '/homes/guest_sign_in', to: 'public/homes#new_guest'
  root to: 'public/homes#top'
  get'about' => 'public/homes#about'
  get "search" => "searches#search"
  delete 'posts/:id' => 'public/posts#destroy', as: 'destroy_post'
  # 顧客用
  # URL /customers/sign_in ...
  devise_for :customers,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
   }

# 管理者用
# URL /admin/sign_in ...
devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}
scope module: :public do
    # 退会確認画面
    get '/customers/:id/bye' => 'customers#bye', as: 'bye'
    # 論理削除用のルーティング
    patch '/customers/:id/adios' => 'customers#adios', as: 'adios'
    resources :posts, only:[:new, :index, :show, :edit, :create, :update] do
    resource :favorites, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
    resources :reposts, only: [:create, :destroy]
    end
    resources :customers, only:[:index, :show, :edit, :update] do
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
        member do
        get :favorites
    end
  end
  end

namespace :admin do
    root :to => 'customers#index'
    resources :posts, only:[:index, :new, :create, :show, :edit, :update]
    resources :customers, only:[:index, :show, :update, :edit]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
