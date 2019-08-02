class LibraryController < ApplicationController
  get '/lib' do
    erb :'/library/index'
  end

  get '/lib/new' do
    erb :'/library/new'
  end

  post '/lib' do

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
