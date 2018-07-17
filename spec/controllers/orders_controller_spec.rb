require 'rails_helper'

describe OrdersController, type: :controller do
  let(:product) { Product.create!(name: "race bike") }
  let(:admin) { User.create!(email: "admin@mail.com", password: "123456", admin: true) }
  let(:simple_user) { User.create!(email: "simple_user@mail.com", password: "123456")}
  let(:order_admin) { Order.create!(user_id: admin.id, product_id: product.id) }
  let(:order_simple_user) { Order.create!(user_id: simple_user.id, product_id: product.id) }

  ########################### INDEX ###########################
  describe "GET #index" do
    context "when user is logged in" do

      context "when simple_user is logged in" do
        before do
          sign_in simple_user
        end

        it "can access #index" do
          get :index
          expect(response).to be_ok
          expect(response).to render_template('index')
        end

      end

    end

    context "when user is not logged in" do
      it "redirects to login" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end

  ########################### SHOW ###########################
  describe "GET #show" do

    context "when user is logged in" do
      context "when admin is logged in" do
        before do
          sign_in admin
        end

        it "loads correct order details" do
          get :show, params: { id: order_admin.id }
          expect(assigns(:order)).to eq order_admin
          expect(response).to be_ok
          expect(response).to render_template('show')
        end

        it "can access /order_simple_user" do
          get :show, params: {id: order_simple_user.id}
          expect(assigns(:order)).to eq order_simple_user
          expect(response).to be_ok
          expect(response).to render_template('show')
        end
      end

      context "when simple_user is logged in" do
        before do
          sign_in simple_user
        end

        it "can access /order_simple_user" do
          get :show, params: { id: order_simple_user.id }
          expect(assigns(:order)).to eq order_simple_user
          expect(response).to be_ok
          expect(response).to render_template('show')
        end

        it "cannot access /order_admin" do
          get :show, params: {id: order_admin.id}
          expect(assigns(:order)).to eq order_admin
          expect(response).to have_http_status(302)
          expect(response).to redirect_to(root_path)
        end
      end

    end

    context "when user is not logged in" do
      it "redirects to login" do
        get :show, params: { id: admin.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end

end
