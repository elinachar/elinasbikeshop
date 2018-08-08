require 'rails_helper'

describe OrdersController, type: :controller do

  before do
    @product = FactoryBot.create(:product)
    @user = FactoryBot.create(:user)
    @admin = FactoryBot.create(:admin)
    @order_user = FactoryBot.create(:order, user: @user, product: @product)
    @order_admin = FactoryBot.create(:order, user: @admin, product: @product)
  end

  ########################### GET ###########################
  ################ INDEX - SHOW -NEW - EDIT #################

  ########################### INDEX ###########################
  describe "GET #index" do
    context "when user is logged in" do
      context "when simple user is logged in" do
        before do
          sign_in @user
        end

        it "populates an array of products" do
          get :index
          expect(assigns(:orders)).to eq [@order_user]
        end

        it "renders the index template" do
          get :index
          expect(response).to be_ok
          expect(response).to render_template :index
        end
      end

      context "when admin is logged in" do
        before do
          sign_in @admin
        end

        it "populates an array of products" do
          get :index
          expect(assigns(:orders)).to eq [@order_admin]
        end

        it "renders the index template" do
          get :index
          expect(response).to be_ok
          expect(response).to render_template :index
        end
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  ########################### SHOW ###########################
  describe "GET #show" do
    context "when user is logged in" do
      context "when simple user is logged in" do
        before do
          sign_in @user
        end

        it "can access /order_user" do
          get :show, params: { id: @order_user.id }
          expect(assigns(:order)).to eq @order_user
          expect(response).to be_ok
          expect(response).to render_template :show
        end

        it "cannot access /order_admin" do
          get :show, params: {id: @order_admin.id}
          expect(assigns(:order)).to eq @order_admin
          expect(response).to have_http_status(302)
          expect(response).to redirect_to root_path
        end
      end

      context "when admin is logged in" do
        before do
          sign_in @admin
        end

        it "can access /order_admin" do
          get :show, params: { id: @order_admin.id }
          expect(assigns(:order)).to eq @order_admin
          expect(response).to be_ok
          expect(response).to render_template :show
        end

        it "can access /order_user" do
          get :show, params: {id: @order_user.id}
          expect(assigns(:order)).to eq @order_user
          expect(response).to be_ok
          expect(response).to render_template :show
        end
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        get :show, params: { id: @admin.id }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end
