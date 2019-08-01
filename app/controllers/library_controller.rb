class LibraryController < ApplicationController
  get '/lib' do
    erb :index
  end
end
