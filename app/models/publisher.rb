class Publisher < ApplicationRecord
    has_many :books, dependent: :destroy
    validates_presence_of :name
end
