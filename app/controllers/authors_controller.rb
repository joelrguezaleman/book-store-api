class AuthorsController < ActionController::API
  include ExceptionHandler

  def create
    author = Author.create!(params.permit(:name))
    render json: {:id => author.id, :url => "/authors/#{author.id}"}, status: :created
  end

  def index
    authors = Author.all
    render json: authors, status: :ok
  end

  def show
    author = Author.find(params[:id])
    render json: author, status: :ok
  end

  def update
    author = Author.find_by_id(params[:id])
    if author == nil then
        Author.create!(id: params[:id], name: params.permit(:name)['name'])
        render json: {:url => "/authors/#{params[:id]}"}, status: :created
    else
        author.update(params.permit(:name))
        head :no_content
    end
  end
end