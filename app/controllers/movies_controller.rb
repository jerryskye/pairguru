class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:send_info, :add_comment, :remove_comment]

  def index
    @movies = Movie.all.decorate
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def add_comment
    @movie = Movie.find(params[:id])
    if current_user.comments.where(movie: @movie).exists?
      redirect_back(fallback_location: root_path, alert: 'You can only post one comment on a movie.')
    else
      @movie.comments.create(author: current_user, body: params.dig(:comment, :body))
      redirect_back(fallback_location: root_path, notice: 'Comment created')
    end
  end

  def remove_comment
    @movie = Movie.find(params[:id])
    current_user.comments.where(movie: @movie).destroy_all
    redirect_back(fallback_location: root_path, notice: 'Comment removed')
  end

  def send_info
    @movie = Movie.find(params[:id])
    MovieInfoMailer.send_info(current_user, @movie).deliver_now
    redirect_back(fallback_location: root_path, notice: "Email sent with movie info")
  end

  def export
    file_path = "tmp/movies.csv"
    MovieExporter.new.call(current_user, file_path)
    redirect_to root_path, notice: "Movies exported"
  end
end
