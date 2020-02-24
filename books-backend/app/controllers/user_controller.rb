class UserController < ApplicationController
  use Rack::Flash

  get '/signup' do
    if !logged_in?
      erb :'/users/create_user'
    else
      flash[:message] = "'flash_good'>You must first sign out to create a new user"
      redirect to '/lib'
    end
  end

  post '/signup' do
    if !params.values.any?("") && !User.find_by(username: params[:username])
      @user = User.create(params)
      session[:user_id] = @user.id
      redirect to '/lib/new'
    else
      flash[:message] = "'flash_bad'>Please fill out all fields"
      redirect to '/signup'
    end
  end

  get '/login' do
    if !logged_in?
      erb :'/users/login'
    else
      flash[:message] = "'flash_good'>You are already logged in!"
      redirect to '/lib'
    end
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to '/lib'
    else
      flash[:message] = "'flash_bad'>Please try again"
      redirect to '/login'
    end
  end

  get '/logout' do
    if logged_in?
      erb :'/users/logout'
    else
      flash[:message] = "'flash_bad'>You are already logged out"
      redirect to '/login'
    end
  end

  post '/logout' do
    session.clear
    redirect to '/login'
  end
end
