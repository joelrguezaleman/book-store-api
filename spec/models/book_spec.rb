require 'rails_helper'

RSpec.describe Book, type: :model do
  it { should have_and_belong_to_many(:authors) }
  it { should have_and_belong_to_many(:genres) }
  it { should belong_to(:publisher) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:pages) }
end
