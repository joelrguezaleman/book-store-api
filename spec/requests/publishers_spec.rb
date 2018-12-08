require 'rails_helper'

RSpec.describe 'Publishers API', type: :request do
  let!(:publishers) { create_list(:publisher, 5) }
  let(:publisher_id) { publishers.first.id }
  let(:unknown_publisher_id) { 999 }

  describe 'GET /publishers' do
    context 'when there are some publishers' do
      it 'returns the full list of publishers' do
        get '/publishers'

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).size).to eq(5)
      end
    end
  end

  describe 'GET /publishers/:id' do
    context 'when the publisher exists' do
      it 'returns the publisher' do
        get "/publishers/#{publisher_id}"

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['id']).to eq(publisher_id)
      end
    end

    context 'when the publisher does not exist' do
      it 'returns status code 404 and an error message' do
        get "/publishers/#{unknown_publisher_id}"

        expect(response).to have_http_status(404)
        expect(response.body).to match(/Couldn't find Publisher with 'id'=#{unknown_publisher_id}/)
      end
    end
  end

  describe 'POST /publishers' do
    context 'when the request is valid' do
      it 'returns the id of the new publisher' do
        post "/publishers", params: {:name => "Penguin Random House"}

        expect(response).to have_http_status(201)
        expect(JSON.parse(response.body)['id']).to be_an(Integer)
        expect(JSON.parse(response.body)['url']).to eq('/publishers/6')

        get "/publishers/6"

        expect(JSON.parse(response.body)['name']).to eq("Penguin Random House")
      end
    end

    context 'when the request is invalid' do
      it 'returns status code 400 and an error message' do
        post "/publishers", params: {}

        expect(response).to have_http_status(400)
        expect(response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  describe 'PUT /publishers/:id' do
    context 'when the record does not exist' do
      it 'returns status code 201' do
        put "/publishers/#{unknown_publisher_id}", params: {:name => "Penguin Random House"}

        expect(response).to have_http_status(201)
        expect(JSON.parse(response.body)['url']).to eq("/publishers/#{unknown_publisher_id}")

        get "/publishers/#{unknown_publisher_id}"

        expect(JSON.parse(response.body)['name']).to eq("Penguin Random House")
      end
    end

    context 'when the record exists' do
      it 'returns status code 204' do
        put "/publishers/#{publisher_id}", params: {:name => "Penguin Random House"}

        expect(response).to have_http_status(204)
        expect(response.body).to be_empty

        get "/publishers/#{publisher_id}"

        expect(JSON.parse(response.body)['name']).to eq("Penguin Random House")
      end
    end
  end

  describe 'DELETE /publishers/:id' do
    context 'when the record exists' do
      it 'returns status code 204' do
        delete "/publishers/#{publisher_id}"

        expect(response).to have_http_status(204)
        expect(response.body).to be_empty

        get "/publishers/#{publisher_id}"

        expect(response).to have_http_status(404)
      end
    end

    context 'when the record does not exist' do
      it 'returns status code 404' do
        delete "/publishers/#{unknown_publisher_id}"

        expect(response).to have_http_status(404)
        expect(response.body).to match(/Couldn't find Publisher with 'id'=#{unknown_publisher_id}/)
      end
    end
  end
end