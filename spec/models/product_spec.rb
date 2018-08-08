require "rails_helper"

describe Product do
  context "returns products with search term" do
    before do
      @product_black1 = FactoryBot.create(:product, name: "Black product")
      @product_red = FactoryBot.create(:product, name: "Red product")
      @product_black2 = FactoryBot.create(:product, name: "Product black")
    end

    it "returns products with search term" do
      search_term = "black"
      result = Product.search(search_term)
      expect(result).to eq([@product_black1, @product_black2])
    end
  end

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

    it "is not valid without a description" do
      attrs = FactoryBot.attributes_for(:product).except(:description)
      product = Product.new(attrs)
      expect(product).to_not be_valid
    end

    it "is not valid without an image_url" do
      attrs = FactoryBot.attributes_for(:product).except(:image_url)
      product = Product.new(attrs)
      expect(product).to_not be_valid
    end

    it "is not valid without a colour" do
      attrs = FactoryBot.attributes_for(:product).except(:colour)
      product = Product.new(attrs)
      expect(product).to_not be_valid
    end

    it "is not valid without a price" do
      attrs = FactoryBot.attributes_for(:product).except(:price)
      product = Product.new(attrs)
      expect(product).to_not be_valid
    end

    it "is not valid with a non numerical price" do
      @product = FactoryBot.build(:product, price: "string")
      expect(@product).to_not be_valid
    end
  end

end
