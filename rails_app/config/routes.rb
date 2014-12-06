Rails.application.routes.draw do
  get '/' => 'base#redirect'

  resources :tweets, :only => :index

  resources :attacks, :only => [] do
    collection do
      get 'queue'
    end
  end

  namespace :api do
    namespace :tweets do
      get 'length'
      get 'stream'
      get 'color'
    end

    namespace :attacks do
      get 'queue'
      get 'check'
      get 'kill'
    end
  end

  get '/*other' => 'base#redirect'
end
