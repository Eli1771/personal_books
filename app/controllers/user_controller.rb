class UserController < ApplicationController
  get '/signup' do
    erb :'/users/create_user'
  end

  post '/signup' do
    #binding.pry
    if !params.values.any?("")
      @user = User.create(params)
      session[:user_id] = @user.id
      redirect to '/lib/new'
    else
      redirect to '/signup'
    end
  end

  get '/login' do
    erb :'/users/login'
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to '/lib/show/lib'
    else
      redirect to '/login'
    end
  end

end
