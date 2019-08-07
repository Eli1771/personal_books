class LibraryController < ApplicationController
  get '/lib' do
    #binding.pry
    @books = Book.all.select {|book| book.user_id == session[:user_id]}
    erb :'/library/index'
  end

  get '/lib/new' do
    if logged_in?
      @authors = Author.all
      @topics = Topic.all
      @rooms = Room.all
      @cases = Case.all
      erb :'/library/new'
    else
      redirect to '/login'
    end
  end

  post '/lib' do
    #binding.pry
    @book = Book.create(params[:book])
    if !params["author"]["name"].empty?
      @author = Author.find_or_create_by(params["author"])
      @book.authors << @author
    end
    if !params["topic"]["name"].empty?
      @topic = Topic.find_or_create_by(params["topic"])
      @book.topic = @topic
      @book.save
    end
    if !params["case"]["name"].empty? #<--Logic to prevent user from entering unavailable shelf
      @case = Case.find_or_create_by(params["case"])
      @book.case = @case
      @book.save
    end
    if !params["room"]["name"].empty?
      @room = Room.find_or_create_by(params["room"])
      @case.room = @room
      @case.save
    end
    @book.room_id = @book.case.room.id
    @book.save
    @book.user = User.find_by_id(session[:user_id])
    @book.user.rooms << Room.find_by_id(@book.room_id)
    @book.save
    redirect to '/lib'
  end

  get '/lib/show' do
    @user = User.find_by_id(session[:user_id])
    @rooms = @user.rooms
    erb :'/library/show'
  end

  get '/lib/room/:id' do
    #slug room names?
    @user = User.find_by_id(session[:user_id])
    @room = Room.find_by_id(params[:id])
    @cases = @room.cases
    erb :'/library/show/room'
  end

  get '/lib/case/:id' do
    @user = User.find_by_id(session[:user_id])
    @case = Case.find_by_id(params[:id])
    @books = @case.books
    erb :'/library/show/bookcase'
  end

  get '/lib/book/:id' do
    @user = User.find_by_id(session[:user_id])
    @book = Book.find_by_id(params[:id])
    erb :'/library/show/book'
  end

  get '/lib/book/:id/edit' do
    @book = Book.find_by_id(params[:id])
    @authors = Author.all
    @topics = Topic.all
    @rooms = Room.all
    @cases = Case.all
    erb :'/library/edit'
  end

end
