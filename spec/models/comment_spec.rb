require 'rails_helper'

describe Comment do
  context "create new comment validation" do
    let(:product) { Product.create!( name: "Race Bike" ) }
    let(:user) { User.create!(email: "test@mail.com", password: "123456" ) }

    it "is not valid without a user" do
      expect(Comment.new(product: product, body: "Comment", rating: 1 )).not_to be_valid
    end

    it "is not valid without a product" do
      expect(Comment.new(user: user, body: "Comment", rating: 1 )).not_to be_valid
    end

    it "is not valid without a body" do
      expect(Comment.new(user: user, product: product, rating: 1 )).not_to be_valid
    end

    it "is not valid without a rating" do
      expect(Comment.new(user: user, product: product, body: "Comment")).not_to be_valid
    end

    it "is not valid without a rating number" do
      expect(Comment.new(user: user, product: product, body: "Comment", rating: "string")).not_to be_valid
    end
  end
end
