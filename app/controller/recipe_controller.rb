class RecipeController < ApplicationController
  get '/recipes' do
    @user = User.find_by_id(session["user_id"])
    @recipe = Recipe.all
    if User.is_logged_in?(session)
      erb :'/recipes/recipes'
    else
      redirect '/login'
    end
  end

  post '/recipes' do
    if params.empty?
      redirect to "/recipes/new", locals: {message: "Your recipe was empty."}
    else
      @user = User.find_by_id(session["user_id"])
      @recipe = Recipe.create(name: params[:name], ingredients: params[:ingredients], recipe: params[:recipe], user_id: @user.id)
      redirect to "/recipes/#{@recipe.id}", locals: {message: "Successfully created recipe."}
    end
  end

  get '/recipes/new' do
    if User.is_logged_in?(session)
      @user = User.current_user(session)
      erb :'/recipes/create'
    else
      redirect to '/login'
    end
  end

  get '/recipes/:id' do
    if User.is_logged_in?(session)
      @recipe = Recipe.find_by_id(params[:id])
      erb :'recipes/show'
    else
      redirect '/login'
    end
  end

  get '/recipes/:id/edit' do
    @recipe = Recipe.find_by_id(params[:id])
    if User.is_logged_in?(session)
      erb :'/recipes/edit'
    else
      redirect '/login'
    end
  end

  patch '/recipes/:id' do
    @recipe = Recipe.find_by_id(params[:id])
    if params[:name] == "" || params[:ingredients] == "" || params[:recipe] == ""
      redirect "/recipes/#{@recipe.id}/edit"
    else
      @recipe.name = params[:name]
      @recipe.ingredients = params[:ingredients]
      @recipe.recipe = params[:recipe]
      @recipe.save
      redirect "/recipes", locals: {message: "Recipe was successfully edited."}
    end
  end

  delete '/recipes/:id/delete' do
    if User.is_logged_in?(session)
      @recipe = Recipe.find(params[:id])
      if User.current_user(session).id == @recipe.user_id
        @recipe.delete
        redirect '/recipes'
      end
    else
      redirect '/login'
    end
  end
end
