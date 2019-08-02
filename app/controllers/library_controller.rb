class LibraryController < ApplicationController
  get '/lib' do
    erb :'/library/index'
  end

  get '/lib/new' do
    @authors = Author.all
    @topics = Topic.all
    erb :'/library/new'
  end

  post '/lib' do
    binding.pry
    @book = Book.create(params["book"])
    @author = Author.create(params["Randy Alcorn"]) if !params["author"]["name"].empty?

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
