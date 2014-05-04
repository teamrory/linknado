Rails.application.routes.draw do

  root "application#index"

  #
  # get '/auth/:provider/callback', to: 'sessions#create'
  # get '/logout', to: 'sessions#destroy'
  #
  get '/oauth_account' => "sessions#oauth_account"
  get '/linkedin_oauth_url' => 'sessions#generate_linkedin_oauth_url'

  post '/url', to: 'sessions#populate_spreadsheet'

end
