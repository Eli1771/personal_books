class UserController < ApplicationController
  get '/signup' do
    erb :'/users/create_user'
  end

  post '/signup' do
    #binding.pry
    if !params.values.any?("")
      @user = User.create(params)
      redirect to '/lib/new'
    else
      redirect to '/signup'
    end
  end

  get '/login' do
    erb :'/users/login'
  end

  post '/login' do
  end

end
