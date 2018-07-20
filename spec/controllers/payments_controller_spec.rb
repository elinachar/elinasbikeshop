require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do

  before do
    @product = FactoryBot.create(:product)
    @user = FactoryBot.create(:user)
    params[:product_id] = @product.id
  end

  describe "GET #create" do
    before do
      sign_in @user
    end

    it "returns http success" do
      post :create
      expect(response).to have_http_status(:success)
    end
  end

end
