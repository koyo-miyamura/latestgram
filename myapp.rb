# myapp.rb
require 'sinatra/base'

class MyApp < Sinatra::Base
  get '/' do
    'Hello world!'
  end
  
  run! if app_file == $0
end
