require 'rails_helper'

describe ProductsController, type: :controller do
  let(:product) { Product.create!(name: "race bike") }
  let(:admin) { User.create!(email: "admin@mail.com", password: "123456", admin: true) }
  let(:simple_user) { User.create!(email: "simple_user@mail.com", password: "123456")}

  ########################### INDEX and SHOW ###########################
  context 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to be_ok
      expect(response).to render_template('index')
    end
  end

  context 'GET #show' do
    it 'renders the show template' do
      get :show, params: { id: product.id }
      expect(response).to be_ok
      expect(response).to render_template('show')
    end
  end

  ########################### EDIT ###########################
  describe "GET #edit" do

    context "when user is logged in" do
      context "when admin is logged in" do
        before do
          sign_in admin
        end

        it "can access /product.id/edit" do
          get :edit, params: {id: product.id}
          expect(response).to be_ok
          expect(response).to render_template('edit')
          expect(assigns(:product)).to eq product
        end
      end

      context "when simple_user is logged in" do
        before do
          sign_in simple_user
        end

        it "cannot access /product.id/edit" do
          get :edit, params: { id: product.id}
          expect(assigns(:product)).to eq product
          expect(response).to have_http_status(302)
          expect(response).to redirect_to(root_path)
        end
      end

    end

    context "when user is not logged in" do
      it "cannot access /product.id/edit" do
        get :edit, params: { id: product.id }
        expect(assigns(:product)).to eq product
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(root_path)

      end
    end

  end

  ########################### DELETE ###########################
  describe "GET #destroy" do

    context "when user is logged in" do
      context "when admin is logged in" do
        before do
          sign_in admin
        end

        it "can access /destroy" do
          delete :destroy, params: {id: product.id}
          expect(response).to have_http_status(302)
          expect(assigns(:product)).to eq product
        end
      end

      context "when simple_user is logged in" do
        before do
          sign_in simple_user
        end

        it "cannot access /destroy" do
          delete :destroy, params: { id: product.id}
          expect(assigns(:product)).to eq product
          expect(response).to have_http_status(302)
          expect(response).to redirect_to(root_path)
        end
      end

    end

    context "when user is not logged in" do
      it "cannot access /destroy" do
        delete :destroy, params: { id: product.id}
        expect(assigns(:product)).to eq product
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(root_path)

      end
    end

  end
end
