class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # initialize session
    session[:params] = {} unless session[:params]

    if params[:ratings].to_a.length == 0 && session[:params]["ratings"].to_a.length > 0
      new_params = {}
      session[:params].each do |k,v|
        new_params.merge!(k => v) unless k.to_s.include?(:ratings.to_s)
        new_params.merge!(k => v) unless k.to_s.include?(:controller.to_s)
        new_params.merge!(k => v) unless k.to_s.include?(:action.to_s)
        new_params.merge!(k => session[:params]["ratings"]) if k.to_s.include?(:ratings.to_s)
      end

      redirect_to movies_path(new_params)
    end
    
    @all_ratings = Movie.movie_ratings
    @selected_key_ratings = params[:ratings].map{ | k,v |  k }.to_a if params[:ratings]
    @selected_key_ratings = {} unless params[:ratings]

    ratings_where = @all_ratings unless params[:ratings]
    ratings_where = @selected_key_ratings if params[:ratings]
    
    @movies = Movie.all.where(rating: ratings_where).order(params[:sort_param])

    common_url_params = {}
    @title_url_param = {}
    @release_date_url_param = {}
    
    params.each do |k,v|
      common_url_params.merge!(k => v) unless k.to_s.include?(:sort_param.to_s)
    end
    
    @title_url_param.merge!(common_url_params).merge!(:sort_param => "title")
    @release_date_url_param.merge!(common_url_params).merge!(:sort_param => "release_date")
    
    #save session
    params.each do |k,v|
      session[:params].merge!(k => v) unless k.to_s.include?(:ratings.to_s) and params[:ratings].to_a.length == 0
      session[:params].merge!(k => v) if k.to_s.include?(:ratings.to_s) and params[:ratings].to_a.length > 0
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
