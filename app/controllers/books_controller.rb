class BooksController < ActionController::API
  include ExceptionHandler

  before_action :set_book, only: [:show, :destroy]
  before_action :get_valid_parameters, only: [:create, :update]

  def set_book
    @book = Book.find(params[:id])
  end

  def get_valid_parameters
    permitted_parameters = params.permit(:title, :pages, :authors_ids, :publisher_id)
    @title = permitted_parameters['title']
    @pages = permitted_parameters['pages']
    authors_ids = permitted_parameters['authors_ids']
    publisher_id = permitted_parameters['publisher_id']
    if @title == nil or @pages == nil or authors_ids == nil or publisher_id == nil then
        render json: {
            message: "'title', 'pages', 'authors_ids' and 'publisher_id' parameters are required"
        }, status: :bad_request
        return
    end
    _read_authors_from_request(authors_ids)
    _read_publisher_from_request(publisher_id)
  end

  def _read_authors_from_request(authors_ids)
    @authors = []
    begin
        authors_ids = JSON.parse(authors_ids)
    rescue JSON::ParserError => e  
        render json: {
            message: "'authors_ids' has an invalid JSON value"
        }, status: :bad_request
        return
    end 
    if (!authors_ids.kind_of?(Array)) then
        render json: {
            message: "'authors_ids' must be an array in JSON format"
        }, status: :bad_request
        return
    end
    authors_ids.each {
        |author_id|
        author = Author.find_by_id(author_id)
        if author == nil then
            render json: {
                message: "/Couldn't find Author with 'id'=#{author_id}/"
            }, status: :unprocessable_entity
            return
        end
        @authors.push(author)
    }
  end

  def _read_publisher_from_request(publisher_id)
    @publisher = Publisher.find_by_id(publisher_id)
    if @publisher == nil then
        render json: {
            message: "/Couldn't find Publisher with 'id'=#{publisher_id}/"
        }, status: :unprocessable_entity
        return
    end
  end

  def create
    book = Book.create!(title: @title, pages: @pages, publisher: @publisher)
    render json: {:id => book.id, :url => "/books/#{book.id}"}, status: :created
  end

  def destroy
    @book.destroy
    head :no_content
  end

  def index
    render json: Book.all
  end

  def show
    render json: @book
  end

  def update
    book = Book.find_by_id(params[:id])
    if book == nil then
        Book.create!(id: params[:id], title: @title, pages: @pages, publisher: @publisher)
        render json: {:url => "/books/#{params[:id]}"}, status: :created
    else
        book.update(title: @title, pages: @pages, publisher: @publisher)
        head :no_content
    end
  end
end
