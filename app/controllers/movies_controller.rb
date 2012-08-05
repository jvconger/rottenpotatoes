class MoviesController < ApplicationController
  
  # add a comment to test version def control(args)
  # another test comment
  
  def index_options    
    {:sort => session[:sort], :ratings => session[:ratings] }
  end
  
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @all_ratings = Movie.all_ratings
    
    params_changed = false
    
    if (params.key? :sort) 
      session[:sort] = params[:sort]
    elsif (session[:sort])
      params[:sort] = session[:sort]
      params_changed = true
    end
      
    
    if (params.key? :ratings)
      session[:ratings] = params[:ratings]
    elsif (session.key? :ratings)
      params[:ratings] = session[:ratings]
      params_changed = true
    end
    
 

    if (params_changed)
      flash.keep
      redirect_to movies_path(index_options)
      
    else
    
      @order_by = session[:sort]
      
      
      @ratings = session[:ratings]
      
      if !(@order_by=~/title|release_date/)
        @order_by=nil
      end
      
      if !(@ratings.respond_to? :keys)
        @ratings = {}
      end
    
      @movies = Movie.order(@order_by).find_all_by_rating(@ratings.keys)
  
  
      if (@movies == nil)
        @movies = [];
      end
    end


  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path(index_options)
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
    redirect_to movies_path(index_options)
  end

end
