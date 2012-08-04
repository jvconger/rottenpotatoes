class MoviesController < ApplicationController
  
  # add a comment to test version def control(args)
  # another test comment
  

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @all_ratings = Movie.all_ratings
    
    if (params[:sort]) 
      session[:sort] = params[:sort]
    end
    
    if (params.key? :ratings)
      session[:ratings] = params[:ratings]
    elsif !(session.key? :ratings)
      session[:ratings] = {}
      @all_ratings.each do |x|
        session[:ratings][x] =1
      end
    end
    

    @order_by = session[:sort];
    

    
    @ratings = session[:ratings]

    @movies = Movie.order(@order_by).find_all_by_rating(@ratings.keys)


    if (@movies == nil)
      @movies = [];
    end



  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
