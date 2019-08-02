class LibraryController < ApplicationController
  get '/lib' do
    erb :index
  end

  get '/lib/new' do
    erb :'/library/new'
  end

  get '/lib/show/lib' do
    @user = User.find_by_id(session[:user_id])
    erb :'/library/show/lib'
  end
end
