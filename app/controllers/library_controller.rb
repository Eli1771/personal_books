class LibraryController < ApplicationController
  get '/lib' do
    if logged_in?
      #binding.pry
      @books = Book.all.select {|book| book.user == current_user}
      erb :'/library/index'
    else
      redirect to '/login'
    end
  end

  get '/lib/new' do
    if logged_in?
      @books = Book.all.select {|book| book.user == current_user}
      @authors = Author.all.select {|author| author.books.any? {|book| book.user == current_user}}
      @topics = Topic.all.select {|topic| topic.books.any? {|book| book.user == current_user}}
      @rooms = Room.all.select {|room| room.user == current_user}
      @cases = Case.all.select {|bookcase| bookcase.room.user == current_user}
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
      if !params["room"]["name"].empty?
        @room = Room.find_or_create_by(params["room"])
        @case.room = @room
        @case.save
      end
    end
    @book.room_id = @book.case.room.id
    @book.user = User.find_by_id(session[:user_id])
    @book.user.rooms << Room.find_by_id(@book.room_id)
    @book.save
    redirect to '/lib'
  end

  get '/lib/show' do
    if logged_in? && current_user.id == session[:user_id]
      @user = User.find_by_id(session[:user_id])
      @rooms = @user.rooms
      erb :'/library/show'
    else
      redirect to '/login'
    end
  end

  get '/lib/room/:id' do
    if logged_in? && current_user.id == session[:user_id]
      #slug room names?
      @user = User.find_by_id(session[:user_id])
      @room = Room.find_by_id(params[:id])
      @cases = @room.cases
      erb :'/library/show/room'
    else
      redirect to '/login'
    end
  end

  get '/lib/case/:id' do
    #binding.pry
    if logged_in? && current_user.id == session[:user_id]
      @user = User.find_by_id(session[:user_id])
      @case = Case.find_by_id(params[:id])
      @books = @case.books
      erb :'/library/show/bookcase'
    else
      redirect to '/login'
    end
  end

  get '/lib/book/:id' do
    if logged_in? && current_user.id == session[:user_id]
      @user = User.find_by_id(session[:user_id])
      @book = Book.find_by_id(params[:id])
      erb :'/library/show/book'
    else
      redirect to '/login'
    end
  end

  get '/lib/book/:id/edit' do
    @book = Book.find_by_id(params[:id])
    if logged_in? && current_user == @book.user
      @books = Book.all.select {|book| book.user == current_user}
      @authors = Author.all.select {|author| author.books.any? {|book| book.user == current_user}}
      @topics = Topic.all.select {|topic| topic.books.any? {|book| book.user == current_user}}
      @rooms = Room.all.select {|room| room.user == current_user}
      @cases = Case.all.select {|bookcase| bookcase.room.user == current_user}
      erb :'/library/edit'
    else
      redirect to '/lib'
    end
  end

  patch '/lib/book/:id' do
    #binding.pry
    @user = User.find_by_id(session[:user_id])
    @book = Book.find_by_id(params[:id])
    @book.update(params[:book])

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
      if !params["room"]["name"].empty?
        @room = Room.find_or_create_by(params["room"])
        @case.room = @room
        @case.save
      end
    end
    @book.room_id = @book.case.room.id
    @book.user = User.find_by_id(session[:user_id])
    @book.user.rooms << Room.find_by_id(@book.room_id)
    @book.save
    redirect to "/lib/book/#{@book.id}"
  end

  delete '/lib/book/:id' do
    @book = Book.find_by_id(params[:id])
    @book.delete
    redirect to '/lib'
  end
end
