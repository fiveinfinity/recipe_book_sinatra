class UserController < ApplicationController
  get '/' do
    erb :index
  end

  get '/signup' do
    if User.is_logged_in?(session)
      redirect to '/recipes'
    else
      erb :'users/create_user'
    end
  end

  post '/signup' do
    if params[:username] == 'error'
    # if params[:username] == "" || params[:email] == "" || params[:password] == ""
      # erb :error, :locals => {message: "Your Signup Information was Invalid."}
      redirect '/signup', locals: {message: "Message here."}
    else
      @user = User.create(username: params[:username], email: params[:email], password: params[:password])
      session["user_id"] = @user.id
      redirect '/recipes'
    end
  end

  get '/login' do
    if !User.is_logged_in?(session)
      erb :'/users/login'
    else
      redirect to '/recipes'
    end
  end

  post '/login' do
    @user = User.find_by_username(params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/recipes'
    else
      redirect '/login'
    end
  end

  get '/logout' do
    if session[:user_id] != nil
      session.clear
      redirect to '/'
    end
  end
end
