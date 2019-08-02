class LibraryController < ApplicationController
  get '/lib' do
    erb :index
  end

  get '/lib/new' do
    erb :'/library/new'
  end
end
