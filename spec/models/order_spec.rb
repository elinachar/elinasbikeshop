require 'rails_helper'

describe Order do
  context "create new comment validation" do
    before do
      @product = FactoryBot.create(:product)
      @user = FactoryBot.create(:user)
      @attrs = FactoryBot.attributes_for(:order, product_id: @product.id, user_id: @user.id)
    end

    it "is not valid without a user" do
      @order = Order.new(@attrs.except(:user_id))
      expect(@order).to_not be_valid
    end

    it "is not valid without a product" do
      @order = Order.new(@attrs.except(:product_id))
      expect(@order).to_not be_valid
    end

    it "is not valid without a total price" do
      @order = Order.new(@attrs.except(:total))
      expect(@order).to_not be_valid
    end

    it "is not valid with a non numerical total price" do
      @order = FactoryBot.build(:order, total: "string")
      expect(@order).to_not be_valid
    end
  end
end
