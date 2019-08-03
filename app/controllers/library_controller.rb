class LibraryController < ApplicationController
  get '/lib' do
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
    redirect to '/lib'
  end

  get '/lib/room/:id' do
    @room = Room.find_by_id(params[:id])
    erb :'/library/show/room'
  end

  get '/lib/case/:id' do
    @case = Case.find_by_id(params[:id])
    erb :'/library/show/case'
  end

  get '/lib/book/:id' do
    @book = Book.find_by_id(params[:id])
    erb :'/library/show/book'
  end

end
