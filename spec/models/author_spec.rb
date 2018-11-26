require 'rails_helper'

RSpec.describe Author, type: :model do
  it { should have_and_belong_to_many(:books) }
  it { should validate_presence_of(:name) }
end
