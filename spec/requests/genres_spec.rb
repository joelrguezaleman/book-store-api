require 'rails_helper'

RSpec.describe 'Genres API', type: :request do
  let!(:genres) { create_list(:genre, 5) }
  let(:genre_id) { genres.first.id }
  let(:unknown_genre_id) { 999 }

  describe 'GET /genres' do
    context 'when there are some genres' do
      it 'returns the full list of genres' do
        get '/genres'

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).size).to eq(5)
      end
    end
  end

  describe 'GET /genres/:id' do
    context 'when the genre exists' do
      it 'returns the genre' do
        get "/genres/#{genre_id}"

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['id']).to eq(genre_id)
      end
    end

    context 'when the genre does not exist' do
      it 'returns status code 404 and an error message' do
        get "/genres/#{unknown_genre_id}"

        expect(response).to have_http_status(404)
        expect(response.body).to match(/Couldn't find Genre with 'id'=#{unknown_genre_id}/)
      end
    end
  end

  describe 'POST /genres' do
    context 'when the request is valid' do
      it 'returns the id of the new genre' do
        post "/genres", params: {:name => "Satire"}

        expect(response).to have_http_status(201)
        expect(JSON.parse(response.body)['id']).to be_an(Integer)
        expect(JSON.parse(response.body)['url']).to eq('/genres/6')

        get "/genres/6"

        expect(JSON.parse(response.body)['name']).to eq("Satire")
      end
    end

    context 'when the request is invalid' do
      it 'returns status code 400 and an error message' do
        post "/genres", params: {}

        expect(response).to have_http_status(400)
        expect(response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  describe 'PUT /genres/:id' do
    context 'when the record does not exist' do
      it 'returns status code 201' do
        put "/genres/#{unknown_genre_id}", params: {:name => "Satire"}

        expect(response).to have_http_status(201)
        expect(JSON.parse(response.body)['url']).to eq("/genres/#{unknown_genre_id}")

        get "/genres/#{unknown_genre_id}"

        expect(JSON.parse(response.body)['name']).to eq("Satire")
      end
    end

    context 'when the record exists' do
      it 'returns status code 204' do
        put "/genres/#{genre_id}", params: {:name => "Satire"}

        expect(response).to have_http_status(204)
        expect(response.body).to be_empty

        get "/genres/#{genre_id}"

        expect(JSON.parse(response.body)['name']).to eq("Satire")
      end
    end
  end

  describe 'DELETE /genres/:id' do
    context 'when the record exists' do
      it 'returns status code 204' do
        delete "/genres/#{genre_id}"

        expect(response).to have_http_status(204)
        expect(response.body).to be_empty

        get "/genres/#{genre_id}"

        expect(response).to have_http_status(404)
      end
    end

    context 'when the record does not exist' do
      it 'returns status code 404' do
        delete "/genres/#{unknown_genre_id}"

        expect(response).to have_http_status(404)
        expect(response.body).to match(/Couldn't find Genre with 'id'=#{unknown_genre_id}/)
      end
    end
  end
end