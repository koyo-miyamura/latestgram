ENV['RACK_ENV'] = 'test'

require_relative '../myapp'
require 'minitest/autorun'
require 'rack/test'

class MyAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    MyApp
  end

  def test_my_default
    get '/'
    assert last_response.ok?

    get '/signin'
    assert last_response.ok?

    get '/signup'
    assert last_response.ok?    
  end
end