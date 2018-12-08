require 'rails_helper'

RSpec.describe 'Authors API', type: :request do
  let!(:authors) { create_list(:author, 5) }
  let(:author_id) { authors.first.id }
  let(:unknown_author_id) { 999 }

  describe 'GET /authors' do
    context 'when there are some authors' do
      it 'returns the full list of authors' do
        get '/authors'

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).size).to eq(5)
      end
    end
  end

  describe 'GET /authors/:id' do
    context 'when the author exists' do
      it 'returns the author' do
        get "/authors/#{author_id}"

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['id']).to eq(author_id)
      end
    end

    context 'when the author does not exist' do
      it 'returns status code 404 and an error message' do
        get "/authors/#{unknown_author_id}"

        expect(response).to have_http_status(404)
        expect(response.body).to match(/Couldn't find Author with 'id'=#{unknown_author_id}/)
      end
    end
  end

  describe 'POST /authors' do
    context 'when the request is valid' do
      it 'returns the id of the new author' do
        post "/authors", params: {:name => "George Orwell"}

        expect(response).to have_http_status(201)
        expect(JSON.parse(response.body)['id']).to be_an(Integer)
        expect(JSON.parse(response.body)['url']).to eq('/authors/6')

        get "/authors/6"

        expect(JSON.parse(response.body)['name']).to eq("George Orwell")
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

  describe 'PUT /authors/:id' do
    context 'when the record does not exist' do
      it 'returns status code 201' do
        put "/authors/#{unknown_author_id}", params: {:name => "George Orwell"}

        expect(response).to have_http_status(201)
        expect(JSON.parse(response.body)['url']).to eq("/authors/#{unknown_author_id}")

        get "/authors/#{unknown_author_id}"

        expect(JSON.parse(response.body)['name']).to eq("George Orwell")
      end
    end

    context 'when the record exists' do
      it 'returns status code 204' do
        put "/authors/#{author_id}", params: {:name => "George Orwell"}

        expect(response).to have_http_status(204)
        expect(response.body).to be_empty

        get "/authors/#{author_id}"

        expect(JSON.parse(response.body)['name']).to eq("George Orwell")
      end
    end
  end

  describe 'DELETE /authors/:id' do
    context 'when the record exists' do
      it 'returns status code 204' do
        delete "/authors/#{author_id}"

        expect(response).to have_http_status(204)
        expect(response.body).to be_empty

        get "/authors/#{author_id}"

        expect(response).to have_http_status(404)
      end
    end

    context 'when the record does not exist' do
      it 'returns status code 404' do
        delete "/authors/#{unknown_author_id}"

        expect(response).to have_http_status(404)
        expect(response.body).to match(/Couldn't find Author with 'id'=#{unknown_author_id}/)
      end
    end
  end
end