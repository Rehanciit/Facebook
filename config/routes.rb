Rails.application.routes.draw do
  devise_for :users , controllers: {registrations: 'user/registrations'}

  root "home#index"

  put 'like/:id', to: 'likes#like', as: :like
  delete 'unlike/:id', to: 'likes#unlike', as: :unlike

  get 'comment/:post_id', to: 'comments#new', as: :newcomment
  get 'comment/:post_id/:parent_comment_id', to: 'comments#new', as: :newreply
  get 'friends', to: 'friend_requests#index', as: :friends
  put 'friend_request/:receiver_id', to: 'friend_requests#create', as: :sendfriendrequest
  delete 'friend_request/:receiver_id', to: 'friend_requests#destroy', as: :deletefriendrequest
  put 'accept_request/:sender_id/:accept', to: 'friend_requests#update', as: :acceptfriendrequest

  resources :comments
  resources :posts
end
