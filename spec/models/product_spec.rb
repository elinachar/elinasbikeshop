require 'rails_helper'

describe Product do
  context "when the product has comments" do
    let(:product) { Product.create!( name: "Race Bike" ) }
    let(:user) { User.create!(email: "test@mail.com", password: "123456" ) }
    before do
      product.comments.create!(rating: 1, user: user, body: "Awful bike!")
      product.comments.create!(rating: 3, user: user, body: "Ok bike!")
      product.comments.create!(rating: 5, user: user, body: "Great bike!")
    end

    it "returns the average rating of all comments" do
      expect(product.average_rating).to eq 3
    end

    it "returns the highest rating of all comments" do
      expect(product.highest_rating_comment).to eq product.comments.last
    end

    it "returns the lowest rating of all comments" do
      expect(product.lowest_rating_comment).to eq product.comments.first
    end
  end

  context "create new product validation" do

    it "is not valid without a name" do
      expect(Product.new(description: "Nice Bike")).not_to be_valid
    end

  end
end
