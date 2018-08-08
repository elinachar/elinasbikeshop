require 'rails_helper'

describe ProductsController, type: :controller do

  before do
    @product = FactoryBot.create(:product)
    @user = FactoryBot.create(:user)
    @admin = FactoryBot.create(:admin)
  end

  ########################### GET ###########################
  ################ INDEX - SHOW -NEW - EDIT #################

  ########################### INDEX ###########################
  describe 'GET #index' do
    it "populates an array of products" do
      get :index
      expect(assigns(:products)).to eq [@product]
    end

    it 'renders the index template' do
      get :index
      expect(response).to be_ok
      expect(response).to render_template :index
    end
  end

  ########################### SHOW ###########################
  describe 'GET #show' do
    it "assigns the requested product to @product" do
      get :show,  params: { id: @product.id }
      expect(assigns(:product)).to eq @product
    end

    it 'renders the show template' do
      get :show, params: { id: @product.id }
      expect(response).to render_template :show
    end
  end

  ########################### NEW ###########################
  describe "GET #new" do
    context "when user is logged in" do
      context "when simple user is logged in" do
        before do
          sign_in @user
        end

        it "cannot access /products/new and redirects to root_path" do
          get :new
          expect(response).to have_http_status(302)
          expect(response).to redirect_to root_path
        end
      end

      context "when admin is logged in" do
        before do
          sign_in @admin
        end

        it "can access /products/new" do
          get :new
          expect(response).to render_template :new
        end
      end
    end

    context "when user is not logged in" do
      it "cannot access /products/new and redirects to root_path" do
        get :new
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
    end
  end

  ########################### EDIT ###########################
  describe "GET #edit" do
    context "when user is logged in" do
      context "when simple user is logged in" do
        before do
          sign_in @user
        end

        it "assigns the requested product to @product" do
          get :edit, params: { id: @product.id}
          expect(assigns(:product)).to eq @product
        end

        it "cannot access /product.id/edit and redirects to root_path" do
          get :edit, params: { id: @product.id}
          expect(response).to have_http_status(302)
          expect(response).to redirect_to root_path
        end
      end

      context "when admin is logged in" do
        before do
          sign_in @admin
        end

        it "assigns the requested product to @product" do
          get :edit, params: { id: @product.id}
          expect(assigns(:product)).to eq @product
        end

        it "can access /product.id/edit" do
          get :edit, params: {id: @product.id}
          expect(response).to be_ok
          expect(response).to render_template :edit
        end
      end
    end

    context "when user is not logged in" do
      it "assigns the requested product to @product" do
        get :edit, params: { id: @product.id}
        expect(assigns(:product)).to eq @product
      end

      it "cannot access /product.id/edit and redirects to root_path" do
        get :edit, params: { id: @product.id}
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
    end
  end

  ############################ POST ############################
  ########################### CREATE ###########################
  describe "POST #create" do
    context "when user is logged in" do
      context "when simple user is logged in" do
        before do
          sign_in @user
        end

        it "cannot create product" do
          expect{
            post :create, params: { product: FactoryBot.attributes_for(:product) }
          }.to_not change(Product,:count)
        end

        it "redirects to root_path" do
          post :create, params: { product: FactoryBot.attributes_for(:product) }
          expect(response).to redirect_to root_path
        end
      end

      context "when admin is logged in" do
        before do
          sign_in @admin
        end

        context "with valid attributes" do
          it "creates a new product" do
            expect{
              post :create, params: { product: FactoryBot.attributes_for(:product) }
            }.to change(Product,:count).by(1)
          end

          it "redirects to the new product" do
            post :create, params: { product: FactoryBot.attributes_for(:product) }
            expect(response).to redirect_to Product.last
          end
        end

        context "with invalid attributes" do
          it "does not save the new product" do
            expect{
              post :create, params: { product: FactoryBot.attributes_for(:product).except(:colour) }
            }.to_not change(Product,:count)
          end

          it "re-renders the new method" do
            post :create, params: { product: FactoryBot.attributes_for(:product).except(:colour) }
            expect(response).to render_template :new
          end
        end
      end
    end

    context "when user is not logged in" do
      it "cannot create product" do
        expect{
          post :create, params: { product: FactoryBot.attributes_for(:product) }
        }.to_not change(Product,:count)
      end

      it "redirects to root_path" do
        post :create, params: { product: FactoryBot.attributes_for(:product) }
        expect(response).to redirect_to root_path
      end
    end
  end

  ########################## PUT #############################
  ######################### UPDATE ###########################
  describe 'PUT #update' do
    context "when user is logged in" do
      context "when simple user is logged in" do
        before do
          sign_in @user
        end

        it "cannot not change @product's attributes" do
          put :update, params: { id: @product.id, product: FactoryBot.attributes_for(:product, name: "Updated name", description: "This is an updated product", colour: "updated_colour", price: 200, image_url: "/updated_image") }
          @product.reload
          expect(@product.name).to eq "Product"
          expect(@product.description).to_not eq "This is an updated product"
          expect(@product.colour).to_not eq "updated_colour"
          expect(@product.price).to_not eq 200
          expect(@product.image_url).to_not eq "/updated_image"
        end

        it "redirects to root_path" do
          put :update, params: { id: @product.id, product: FactoryBot.attributes_for(:product) }
          expect(response).to redirect_to root_path
        end
      end

      context "when admin is logged in" do
        before do
          sign_in @admin
        end

        context "valid attributes" do
          it "assigns the requested product to @product" do
            put :update, params: { id: @product.id, product: FactoryBot.attributes_for(:product) }
            expect(assigns(:product)).to eq @product
          end

          it "changes @product's attributes" do
            put :update, params: { id: @product.id, product: FactoryBot.attributes_for(:product, name: "Updated Product", description: "This is an updated product", colour: "updated colour", price: "200", image_url: "/updated_image") }
            @product.reload
            expect(@product.name).to eq "Updated Product"
            expect(@product.description).to eq "This is an updated product"
            expect(@product.colour).to eq "updated colour"
            expect(@product.price).to eq 200
            expect(@product.image_url).to eq "/updated_image"
          end

          it "redirects to the updated product" do
            put :update, params: { id: @product.id, product: FactoryBot.attributes_for(:product) }
            expect(response).to redirect_to @product
          end
        end

        context "invalid attributes" do
          it "locates the requested @product" do
            put :update, params: { id: @product.id, product: FactoryBot.attributes_for(:invalid_product) }
            expect(assigns(:product)).to eq @product
          end

          it "does not change @product's attributes" do
            put :update, params: { id: @product.id, product: FactoryBot.attributes_for(:product, name: nil, description: "This is an updated product", colour: "updated_colour", price: 200, image_url: "/updated_image") }
            @product.reload
            expect(@product.name).to eq "Product"
            expect(@product.description).to_not eq "This is an updated product"
            expect(@product.colour).to_not eq "updated_colour"
            expect(@product.price).to_not eq 200
            expect(@product.image_url).to_not eq "/updated_image"
          end

          it "re-renders the edit method" do
            put :update, params: { id: @product.id, product: FactoryBot.attributes_for(:invalid_product) }
            expect(response).to render_template :edit
          end
        end
      end
    end

    context "when user is not logged in" do
      it "cannot not change @product's attributes" do
        put :update, params: { id: @product.id, product: FactoryBot.attributes_for(:product, name: "Updated name", description: "This is an updated product", colour: "updated_colour", price: 200, image_url: "/updated_image") }
        @product.reload
        expect(@product.name).to eq "Product"
        expect(@product.description).to_not eq "This is an updated product"
        expect(@product.colour).to_not eq "updated_colour"
        expect(@product.price).to_not eq 200
        expect(@product.image_url).to_not eq "/updated_image"
      end

      it "redirects to root_path" do
        put :update, params: { id: @product.id, product: FactoryBot.attributes_for(:product) }
        expect(response).to redirect_to root_path
      end
    end
  end

  ########################### DELETE ###########################
  ########################### DESTROY ###########################
  describe "DELETE #destroy" do
    context "when user is logged in" do
      context "when simple user is logged in" do
        before do
          sign_in @user
        end

        it "cannot delete the product" do
          expect{
            delete :destroy, params: {id: @product.id}
          }.to_not change(Product,:count)
        end

        it "cannot access /destroy and redirects to root_path" do
          delete :destroy, params: { id: @product.id}
          expect(assigns(:product)).to eq @product
          expect(response).to have_http_status(302)
          expect(response).to redirect_to root_path
        end
      end

      context "when admin is logged in" do
        before do
          sign_in @admin
        end

        it "assigns the requested product to @product" do
          delete :destroy, params: {id: @product.id}
          expect(assigns(:product)).to eq @product
        end

        it "can access /destroy" do
          delete :destroy, params: {id: @product.id}
          expect(response).to redirect_to products_url
        end

        it "deletes the product" do
          expect{
            delete :destroy, params: {id: @product.id}
          }.to change(Product,:count).by(-1)
        end

        it "redirects to products#index" do
          delete :destroy, params: {id: @product.id}
          expect(response).to redirect_to products_url
        end
      end
    end

    context "when user is not logged in" do
      it "cannot delete the product" do
        expect{
          delete :destroy, params: {id: @product.id}
        }.to_not change(Product,:count)
      end

      it "cannot access /destroy and redirects to root_path" do
        delete :destroy, params: { id: @product.id}
        expect(assigns(:product)).to eq @product
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
    end
  end

end
