class Book < ApplicationRecord
    has_and_belongs_to_many :authors
    has_and_belongs_to_many :genres
    has_one :publisher
end
