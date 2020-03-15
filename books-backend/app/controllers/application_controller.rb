require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  get "/" do
    if !logged_in?
      erb :index
    else
      redirect to '/lib'
    end
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      user ||= User.find_by_id(session[:user_id])
    end

    def redirect_if_not_logged_in
      if !logged_in?
        flash[:message] = "'flash_bad'>You must be logged in to view your library"
        redirect to '/login'
      end
    end

    def redirect_if_not_authorized(book_user)
      if current_user != book_user
        flash[:message] = "'flash_bad'>You can only alter your own library!"
        redirect to '/lib'
      end
    end
  end


  get '/test/show' do
    @out = CsvParser.parse
    erb :'/test/show'
  end
end
