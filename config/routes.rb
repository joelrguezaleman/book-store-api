Rails.application.routes.draw do
  resources :authors do
  end
  resources :books do
  end
  resources :genres do
  end
  resources :publishers do
  end
end
