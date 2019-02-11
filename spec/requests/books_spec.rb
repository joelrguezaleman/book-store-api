require 'rails_helper'

RSpec.describe 'Books API', type: :request do
  let!(:books) {
    create_list(:book, 5)
  }
  let(:book_id) { books.first.id }
  let(:author) { books.first.authors.first }
  let(:publisher) { books.first.publisher }
  let(:unknown_book_id) { 999 }

  describe 'GET /books' do
    context 'when there are some books' do
      it 'returns the full list of books' do
        get '/books'

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).size).to eq(5)
      end
    end
  end

  describe 'GET /books/:id' do
    context 'when the book exists' do
      it 'returns the book' do
        get "/books/#{book_id}"

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['id']).to eq(book_id)
      end
    end

    context 'when the book does not exist' do
      it 'returns status code 404 and an error message' do
        get "/books/#{unknown_book_id}"

        expect(response).to have_http_status(404)
        expect(response.body).to match(/Couldn't find Book with 'id'=#{unknown_book_id}/)
      end
    end
  end

  describe 'POST /books' do
    context 'when the request is valid' do
      it 'returns the id of the new book' do
        post "/books", params: {
          :title => "Animal Farm",
          :pages => 112,
          :authors_ids => JSON.generate([author.id]),
          :publisher_id => publisher.id
        }

        expect(response).to have_http_status(201)
        expect(JSON.parse(response.body)['id']).to be_an(Integer)
        expect(JSON.parse(response.body)['url']).to eq('/books/6')

        get "/books/6"

        expect(JSON.parse(response.body)['title']).to eq("Animal Farm")
      end
    end

    context 'when the request is invalid' do
      it 'returns status code 400' do
        post "/books", params: {}

        expect(response).to have_http_status(400)
        expect(response.body).to match(
          /'title', 'pages', 'authors_ids' and 'publisher_id' parameters are required/
        )
      end
    end

    context 'when the author does not exist' do
      it 'returns status code 422' do
        unknown_author_id = 2934759;
        post "/books", params: {
          :title => "Animal Farm",
          :pages => 112,
          :authors_ids => JSON.generate([unknown_author_id]),
          :publisher_id => publisher.id
        }

        expect(response).to have_http_status(422)
        expect(response.body).to match(/Couldn't find Author with 'id'=#{unknown_author_id}/)
      end
    end

    context 'when authors_ids is not an array' do
      it 'returns status code 400' do
        post "/books", params: {
          :title => "Animal Farm",
          :pages => 112,
          :authors_ids => JSON.generate('whatever'),
          :publisher_id => publisher.id
        }

        expect(response).to have_http_status(400)
        expect(response.body).to match(/'authors_ids' must be an array in JSON format/)
      end
    end

    context 'when authors_ids is not a valid JSON' do
      it 'returns status code 400' do
        post "/books", params: {
          :title => "Animal Farm",
          :pages => 112,
          :authors_ids => '{whatever',
          :publisher_id => publisher.id
        }

        expect(response).to have_http_status(400)
        expect(response.body).to match(/'authors_ids' has an invalid JSON value/)
      end
    end

    context 'when the publisher does not exist' do
      it 'returns status code 422' do
        unknown_publisher_id = 2934759;
        post "/books", params: {
          :title => "Animal Farm",
          :pages => 112,
          :authors_ids => JSON.generate([author.id]),
          :publisher_id => unknown_publisher_id
        }

        expect(response).to have_http_status(422)
        expect(response.body).to match(/Couldn't find Publisher with 'id'=#{unknown_publisher_id}/)
      end
    end
  end

  describe 'PUT /books/:id' do
    context 'when the record does not exist' do
      it 'returns status code 201' do
        put "/books/#{unknown_book_id}", params: {
          :title => "Animal Farm",
          :pages => 112,
          :authors_ids => JSON.generate([author.id]),
          :publisher_id => publisher.id
        }

        expect(response).to have_http_status(201)
        expect(JSON.parse(response.body)['url']).to eq("/books/#{unknown_book_id}")

        get "/books/#{unknown_book_id}"

        expect(JSON.parse(response.body)['title']).to eq("Animal Farm")
      end
    end

    context 'when the record exists' do
      it 'returns status code 204' do
        put "/books/#{book_id}", params: {
          :title => "Animal Farm",
          :pages => 112,
          :authors_ids => JSON.generate([author.id]),
          :publisher_id => publisher.id
        }

        expect(response).to have_http_status(204)
        expect(response.body).to be_empty

        get "/books/#{book_id}"

        expect(JSON.parse(response.body)['title']).to eq("Animal Farm")
      end
    end

    context 'when the author does not exist' do
      it 'returns status code 422' do
        unknown_author_id = 2934759;
        put "/books/#{book_id}", params: {
          :title => "Animal Farm",
          :pages => 112,
          :authors_ids => JSON.generate([unknown_author_id]),
          :publisher_id => publisher.id
        }

        expect(response).to have_http_status(422)
        expect(response.body).to match(/Couldn't find Author with 'id'=#{unknown_author_id}/)
      end
    end

    context 'when authors_ids is not an array' do
      it 'returns status code 400' do
        put "/books/#{book_id}", params: {
          :title => "Animal Farm",
          :pages => 112,
          :authors_ids => JSON.generate('whatever'),
          :publisher_id => publisher.id
        }

        expect(response).to have_http_status(400)
        expect(response.body).to match(/'authors_ids' must be an array in JSON format/)
      end
    end

    context 'when authors_ids is not a valid JSON' do
      it 'returns status code 400' do
        put "/books/#{book_id}", params: {
          :title => "Animal Farm",
          :pages => 112,
          :authors_ids => '{whatever',
          :publisher_id => publisher.id
        }

        expect(response).to have_http_status(400)
        expect(response.body).to match(/'authors_ids' has an invalid JSON value/)
      end
    end

    context 'when the publisher does not exist' do
      it 'returns status code 422' do
        unknown_publisher_id = 2934759;
        put "/books/#{book_id}", params: {
          :title => "Animal Farm",
          :pages => 112,
          :authors_ids => JSON.generate([author.id]),
          :publisher_id => unknown_publisher_id
        }

        expect(response).to have_http_status(422)
        expect(response.body).to match(/Couldn't find Publisher with 'id'=#{unknown_publisher_id}/)
      end
    end
  end

  describe 'DELETE /books/:id' do
    context 'when the record exists' do
      it 'returns status code 204' do
        delete "/books/#{book_id}"

        expect(response).to have_http_status(204)
        expect(response.body).to be_empty

        get "/books/#{book_id}"

        expect(response).to have_http_status(404)
      end
    end

    context 'when the record does not exist' do
      it 'returns status code 404' do
        delete "/books/#{unknown_book_id}"

        expect(response).to have_http_status(404)
        expect(response.body).to match(/Couldn't find Book with 'id'=#{unknown_book_id}/)
      end
    end
  end
end