require 'rails_helper'

describe ProductsController, type: :controller do
  
  before do
    @product = FactoryBot.create(:product)
    @user = FactoryBot.create(:user)
    @admin = FactoryBot.create(:admin)
  end

  ########################### INDEX and SHOW ###########################
  context 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to be_ok
      expect(response).to render_template('index')
    end
  end

  context 'GET #show' do
    it 'renders the show template - loads correct product details' do
      get :show, params: { id: @product.id }
      expect(response).to be_ok
      expect(response).to render_template('show')
    end
  end

  ########################### EDIT ###########################
  describe "GET #edit" do
    context "when user is logged in" do
      context "when user is logged in" do
        before do
          sign_in @user
        end

        it "cannot access /product.id/edit" do
          get :edit, params: { id: @product.id}
          expect(assigns(:product)).to eq @product
          expect(response).to have_http_status(302)
          expect(response).to redirect_to(root_path)
        end
      end

      context "when admin is logged in" do
        before do
          sign_in @admin
        end

        it "can access /product.id/edit" do
          get :edit, params: {id: @product.id}
          expect(assigns(:product)).to eq @product
          expect(response).to be_ok
          expect(response).to render_template('edit')
        end
      end
    end

    context "when user is not logged in" do
      it "cannot access /product.id/edit" do
        get :edit, params: { id: @product.id }
        expect(assigns(:product)).to eq @product
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  ########################### DELETE ###########################
  describe "GET #destroy" do
    context "when user is logged in" do
      context "when user is logged in" do
        before do
          sign_in @user
        end

        it "cannot access /destroy" do
          delete :destroy, params: { id: @product.id}
          expect(assigns(:product)).to eq @product
          expect(response).to have_http_status(302)
          expect(response).to redirect_to(root_path)
        end
      end

      context "when admin is logged in" do
        before do
          sign_in @admin
        end

        it "can access /destroy" do
          delete :destroy, params: {id: @product.id}
          expect(assigns(:product)).to eq @product
          expect(response).to have_http_status(302)
        end
      end
    end

    context "when user is not logged in" do
      it "cannot access /destroy" do
        delete :destroy, params: { id: @product.id}
        expect(assigns(:product)).to eq @product
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(root_path)
      end
    end
  end

end
