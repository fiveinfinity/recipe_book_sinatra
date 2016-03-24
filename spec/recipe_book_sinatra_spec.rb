require_relative "spec_helper"
require './config/environment'

def app
  RecipeBookSinatra
end

describe UserController do
  it "responds with a welcome message" do
    post '/login'

    last_response.body.must_include 'Welcome to the Sinatra Template!'
  end
end
