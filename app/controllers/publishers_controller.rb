class PublishersController < ActionController::API
  include ExceptionHandler

  before_action :set_publisher, only: [:show, :destroy]

  def set_publisher
    @publisher = Publisher.find(params[:id])
  end

  def create
    publisher = Publisher.create!(params.permit(:name))
    render json: {:id => publisher.id, :url => "/publishers/#{publisher.id}"}, status: :created
  end

  def destroy
    @publisher.destroy
    head :no_content
  end

  def index
    publishers = Publisher.all
    render json: publishers
  end

  def show
    render json: @publisher
  end

  def update
    publisher = Publisher.find_by_id(params[:id])
    if publisher == nil then
        Publisher.create!(id: params[:id], name: params.permit(:name)['name'])
        render json: {:url => "/publishers/#{params[:id]}"}, status: :created
    else
        publisher.update(params.permit(:name))
        head :no_content
    end
  end
end
