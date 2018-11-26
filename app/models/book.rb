class Book < ApplicationRecord
    has_and_belongs_to_many :authors
    has_and_belongs_to_many :genres
    belongs_to :publisher
    validates_presence_of :title, :pages
end
