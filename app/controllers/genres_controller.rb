class GenresController < ActionController::API
  include ExceptionHandler

  before_action :set_genre, only: [:show, :destroy]

  def set_genre
    @genre = Genre.find(params[:id])
  end

  def create
    genre = Genre.create!(params.permit(:name))
    render json: {:id => genre.id, :url => "/genres/#{genre.id}"}, status: :created
  end

  def destroy
    @genre.destroy
    head :no_content
  end

  def index
    render json: Genre.all
  end

  def show
    render json: @genre
  end

  def update
    genre = Genre.find_by_id(params[:id])
    if genre == nil then
        Genre.create!(id: params[:id], name: params.permit(:name)['name'])
        render json: {:url => "/genres/#{params[:id]}"}, status: :created
    else
        genre.update(params.permit(:name))
        head :no_content
    end
  end
end
