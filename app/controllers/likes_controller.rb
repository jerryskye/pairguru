class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @movie = Movie.find(params[:movie_id])
    if LikesValidator.validate(movie: @movie, user: current_user)
      Like.create(user: current_user, movie: @movie)
      flash[:notice] = 'Liked the movie successfully'
      redirect_to movie_path(@movie)
    else
      flash[:alert] = 'You already liked this movie'
      redirect_to movie_path(@movie)
    end
  end
end
