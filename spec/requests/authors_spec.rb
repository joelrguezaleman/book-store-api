require 'rails_helper'

RSpec.describe 'Authors API', type: :request do
  describe 'GET /authors' do
    context 'when there are no authors' do
      before { get '/authors' }

      it 'returns an empty list of authors' do
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to be_empty
        expect(JSON.parse(response.body).size).to eq(0)
      end
    end

    context 'when there are some authors' do
      let!(:authors) { create_list(:author, 5) }

      before { get '/authors' }

      it 'returns the full list of authors' do
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).size).to eq(5)
      end
    end
  end

  describe 'GET /authors/:id' do
    let!(:authors) { create_list(:author, 1) }
    let(:author_id) { authors.first.id }

    before { get "/authors/#{author_id}" }

    context 'when the author exists' do
      it 'returns the author' do
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['id']).to eq(author_id)
      end
    end

    context 'when the author does not exist' do
      let(:author_id) { 100 }

      it 'returns status code 404 and an error message' do
        expect(response).to have_http_status(404)
        expect(response.body).to match(/Couldn't find Author with 'id'=#{author_id}/)
      end
    end
  end

  describe 'POST /authors' do
    context 'when the request is valid' do
      it 'returns the id of the new author' do
        post "/authors", params: {:name => "George Orwell"}

        expect(response).to have_http_status(201)
        expect(JSON.parse(response.body)['id']).to be_an(Integer)
      end
    end

    context 'when the request is invalid' do
      it 'returns status code 400 and an error message' do
        post "/authors", params: {}

        expect(response).to have_http_status(400)
        expect(response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end
end