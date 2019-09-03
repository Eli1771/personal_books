class TestDataController < ApplicationController
  get '/test/show' do
    "hello parser"
    #@out = CsvParser.parse
  end
end
