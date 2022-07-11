Rails.application.routes.draw do
  
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
    resources :posts, only:[:new,:index,:show,:edit,:create]
  end
  
namespace :admin do
    root :to => 'homes#top'
    resources :posts, only:[:index, :new, :create, :show, :edit, :update]
    resources :customers, only:[:index, :show, :update, :edit]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
