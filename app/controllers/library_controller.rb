class LibraryController < ApplicationController
  use Rack::Flash

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
    #error handling first
    @error_message = []
    if params["book"]["title"].empty?
      @error_message << "'flash_bad'>A Title is required"
    end
    if params["author"]["name"].empty? && params["book"]["author_ids"].nil?
      @error_message << "'flash_bad'>An Author is required"
    end
    if params["topic"]["name"].empty? && params["book"]["topic_id"].nil?
      @error_message << "'flash_bad'>A Topic is required"
    end
    if params["book"]["shelf_id"].empty?
      @error_message << "'flash_bad'>Please indicate which shelf your book is on"
    end
    if params["case"]["name"].empty? && params["book"]["case_id"].nil?
      @error_message << "'flash_bad'>Please indicate which bookcase your book is in"
    end
    if !params["case"]["name"].empty? && params["case"]["shelf_count"].empty?
      @error_message << "'flash_bad'>A shelf count is required to create a new bookcase"
    end
    if !params["case"]["name"].empty? && params["room"]["name"].empty? && params["case"]["room_id"].nil?
      @error_message << "'flash_bad'>Please indicate which room your new shelf is located in"
      #if you select a case, but the shelf number is higher than the number of available shelves for that case
    end
    if params["case"]["name"].empty? && !params["book"]["case_id"].nil? && params["book"]["shelf_id"].to_i > Case.find_by_id(params["book"]["case_id"]).shelf_count
      @case_error = Case.find_by_id(params["book"]["case_id"])
      @error_message << "'flash_bad'>That shelf is not available for Case #{@case_error.name} in #{@case_error.room.name}"
      #if you create a case with a shelf count, but the book location is higher than the nuber of available shelves for your new case
    end
    if !params["case"]["name"].empty? && !params["case"]["shelf_count"].empty? && params["book"]["shelf_id"].to_i > params["case"]["shelf_count"].to_i
      @error_message << "'flash_bad'>That shelf is not available for your new Bookcase"
    end

    #now render the array into one big error message
    #it should read in HTML as one or more <h3>'s
    if @error_message.count == 1
      flash[:message] = @error_message.first
      redirect to '/lib/new'
    else
      flash[:message] = @error_message.join('</h3><h3 class=')
      redirect to '/lib/new'
    end

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
    if logged_in?
      @user = User.find_by_id(session[:user_id])
      @rooms = @user.rooms
      erb :'/library/show'
    else
      redirect to '/login'
    end
  end

  get '/lib/room/:id' do
    if logged_in?
      #slug room names?
      @user = User.find_by_id(session[:user_id])
      @room = Room.find_by_id(params[:id])
      if @user.rooms.include?(@room)
        @cases = @room.cases
        erb :'/library/show/room'
      else
        redirect to '/lib'
      end
    else
      redirect to '/login'
    end
  end

  get '/lib/case/:id' do
    #binding.pry
    if logged_in?
      @user = User.find_by_id(session[:user_id])
      @case = Case.find_by_id(params[:id])
      if @user.rooms.include?(@case.room)
        @books = @case.books
        erb :'/library/show/bookcase'
      else
        redirect to '/lib'
      end
    else
      redirect to '/login'
    end
  end

  get '/lib/book/:id' do
    if logged_in?
      @user = User.find_by_id(session[:user_id])
      @book = Book.find_by_id(params[:id])
      if @book.user == @user
        erb :'/library/show/book'
      else
        redirect to '/lib'
      end
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
