class UserController < ApplicationController
  get '/signup' do
    if !logged_in?
      erb :'/users/create_user'
    else
      redirect to 'lib/show/lib'
    end
  end

  post '/signup' do
    if !params.values.any?("")
      @user = User.create(params)
      session[:user_id] = @user.id
      redirect to '/lib/new'
    else
      redirect to '/signup'
    end
  end

  get '/login' do
    if !logged_in?
      erb :'/users/login'
    else
      redirect to 'lib/show/lib'
    end
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

  get '/logout' do
    if logged_in?
      erb :'/users/logout'
    else
      redirect to '/login'
    end
  end

  post '/logout' do
    session.clear
    redirect to '/login'
  end
end
