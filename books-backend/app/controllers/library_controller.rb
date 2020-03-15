class LibraryController < ApplicationController
  use Rack::Flash

  get '/lib' do
    redirect_if_not_logged_in
    @books = Book.all.select {|book| book.user == current_user}
    erb :'/library/index'
  end

  get '/lib/new' do
    redirect_if_not_logged_in
    @books = current_user.books.sort_by {|book| book.title.to_s}
    @authors = current_user.authors.sort_by {|author| author.name.to_s}
    @topics = current_user.topics.sort_by {|topic| topic.name.to_s}
    @rooms = current_user.rooms.sort_by {|room| room.name.to_s}
    @cases = current_user.cases.sort_by {|bookcase| bookcase.name.to_s}
    erb :'/library/new'
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
    if @error_message.count > 0
      flash[:message] = @error_message.join('</h3><h3 class=')
      redirect to '/lib/new'
    end

    @book = Book.create(params[:book])
    if !params["author"]["name"].empty?
      @author = Author.find_or_create_by(params["author"])
      @book.authors << @author
      @author.user_id = current_user.id
      @author.save
    end
    if !params["topic"]["name"].empty?
      @topic = Topic.find_or_create_by(params["topic"])
      @book.topic = @topic
      @topic.user_id = current_user.id
      @book.save
    end
    if !params["case"]["name"].empty?
      @case = Case.find_or_create_by(params["case"])
      @book.case = @case
      @book.save
      if !params["room"]["name"].empty?
        @room = Room.find_or_create_by(params["room"])
        @case.room = @room
        @case.user_id = current_user.id
        @case.save
      end
    end
    @book.room_id = @book.case.room.id
    @book.user = current_user
    @book.user.rooms << Room.find_by_id(@book.room_id)
    @book.save
    flash[:message] = "'flash_good'>Successfully added #{@book.title} to your library! "
    redirect to '/lib'
  end

  get '/lib/show' do
    redirect_if_not_logged_in
    @user = current_user
    @rooms = @user.rooms.sort_by {|room| room.name.to_s}
    erb :'/library/show'
  end

  get '/lib/room/:id' do
    redirect_if_not_logged_in
    #slug room names?
    @user = current_user
    @room = Room.find_by_id(params[:id])
    @cases = @room.cases.sort_by {|bookcase| bookcase.name.to_s}
    erb :'/library/show/room'
  end

  get '/lib/case/:id' do #<-- sort by shelf, then alphabet
    #binding.pry
    redirect_if_not_logged_in
    @user = current_user
    @case = Case.find_by_id(params[:id])
    @books = @case.books.sort_by {|book| book.title.to_s}
    erb :'/library/show/bookcase'
  end

  get '/lib/book/:id' do
    redirect_if_not_logged_in
    @user = current_user
    @book = Book.find_by_id(params[:id])
    erb :'/library/show/book'
  end

  get '/lib/book/:id/edit' do
    @book = Book.find_by_id(params[:id])
    redirect_if_not_authorized(@book.user)
    @books = current_user.books.sort_by {|book| book.title.to_s}
    @authors = current_user.authors.sort_by {|author| author.name.to_s}
    @topics = current_user.topics.sort_by {|topic| topic.name.to_s}
    @rooms = current_user.rooms.sort_by {|room| room.name.to_s}
    @cases = current_user.cases.sort_by {|bookcase| bookcase.name.to_s}
    erb :'/library/edit'
  end

  patch '/lib/book/:id' do
    @book = Book.find_by_id(params[:id])
    redirect_if_not_authorized(@book.user)
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
    if @error_message.count > 0
      flash[:message] = @error_message.join('</h3><h3 class=')
      redirect to '/lib/new'
    end

    #binding.pry
    @user = current_user
    @book.update(params[:book])

    if !params["author"]["name"].empty?
      @author = Author.find_or_create_by(params["author"])
      @book.authors << @author
      @author.user_id = current_user.id
      @author.save
    end
    if !params["topic"]["name"].empty?
      @topic = Topic.find_or_create_by(params["topic"])
      @book.topic = @topic
      @topic.user_id = current_user.id
      @book.save
    end
    if !params["case"]["name"].empty? #<--Logic to prevent user from entering unavailable shelf
      @case = Case.find_or_create_by(params["case"])
      @book.case = @case
      @book.save
      if !params["room"]["name"].empty?
        @room = Room.find_or_create_by(params["room"])
        @case.room = @room
        @case.user_id = current_user.id
        @case.save
      end
    end
    @book.room_id = @book.case.room.id
    @book.user = current_user
    @book.user.rooms << Room.find_by_id(@book.room_id)
    @book.save
    flash[:message] = "'flash_good'>Successfully edited #{@book.title}!"
    redirect to "/lib/book/#{@book.id}"
  end

  delete '/lib/book/:id' do
    @book = Book.find_by_id(params[:id])
    redirect_if_not_authorized(@book.user)
    @title = @book.title
    @book.delete
    flash[:message] = "'flash_good'>Successfully deleted #{@title}!"
    redirect to '/lib'
  end
end
