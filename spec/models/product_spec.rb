require 'rails_helper'

describe Product do
  context "when the product has comments" do
    before do
      @product_with_comments = FactoryBot.create(:product_with_comments, comments_count: 3)
      @product_with_comments.comments.first.update_attribute(:rating, 1)
      @product_with_comments.comments.second.update_attribute(:rating, 3)
      @product_with_comments.comments.last.update_attribute(:rating, 5)
    end


    it "returns the average rating of all comments" do
      expect(@product_with_comments.average_rating).to eq 3
    end

    it "returns the highest rating of all comments" do
      expect(@product_with_comments.highest_rating_comment).to eq @product_with_comments.comments.last
    end

    it "returns the lowest rating of all comments" do
      expect(@product_with_comments.lowest_rating_comment).to eq @product_with_comments.comments.first
    end
  end

  context "create new product validation" do

    it "is not valid without a name" do
      attrs = FactoryBot.attributes_for(:product).except(:name)
      product = Product.new(attrs)
      expect(product).to_not be_valid
    end

  end
end
