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
        expect(JSON.parse(response.body)).not_to be_empty
        expect(JSON.parse(response.body).size).to eq(5)
      end
    end
  end
end