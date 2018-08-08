require 'rails_helper'

describe CommentsController, type: :controller do

  before do
    @user = FactoryBot.create(:user)
    @admin = FactoryBot.create(:admin)
    @product = FactoryBot.create(:admin)
    @comment = FactoryBot.create(:comment)
  end

  ############################ POST ############################
  ########################### CREATE ###########################
  describe "POST #create" do
    context "when user is logged in" do
      context "when simple user is logged in" do
        before do
          sign_in @user
        end
        context "with valid attributes" do
          it "can create a comment" do
            expect{
              post :create, params: { product_id: Product.first, comment: FactoryBot.attributes_for(:comment) }
            }.to change(Comment,:count).by(1)
          end

          it "redirects to product_path" do
            post :create, params: { comment: FactoryBot.attributes_for(:comment), product_id: @comment.product }
            expect(response).to redirect_to @comment.product
          end
        end

        context "with invalid attributes" do
          it "does not save a new comment without body" do
            expect{
              post :create, params: { comment: FactoryBot.attributes_for(:comment).except(:body), product_id: @comment.product }
            }.to_not change(Comment,:count)
          end

          it "does not save a new comment without rating" do
            expect{
              post :create, params: { comment: FactoryBot.attributes_for(:comment).except(:rating), product_id: @comment.product }
            }.to_not change(Comment,:count)
          end

          it "re-renders the new method" do
            post :create, params: {  comment: FactoryBot.attributes_for(:comment).except(:body), product_id: @comment.product }
            expect(response).to redirect_to @comment.product
          end
        end
      end

      context "when admin is logged in" do
        before do
          sign_in @admin
        end

        context "with valid attributes" do
          it "can create a comment" do
            expect{
              post :create, params: { product_id: Product.first, comment: FactoryBot.attributes_for(:comment) }
            }.to change(Comment,:count).by(1)
          end

          it "redirects to product_path" do
            post :create, params: { comment: FactoryBot.attributes_for(:comment), product_id: @comment.product }
            expect(response).to redirect_to @comment.product
          end
        end

        context "with invalid attributes" do
          it "does not save a new comment without body" do
            expect{
              post :create, params: { comment: FactoryBot.attributes_for(:comment).except(:body), product_id: @comment.product }
            }.to_not change(Comment,:count)
          end

          it "does not save a new comment without rating" do
            expect{
              post :create, params: { comment: FactoryBot.attributes_for(:comment).except(:rating), product_id: @comment.product }
            }.to_not change(Comment,:count)
          end

          it "re-renders the new method" do
            post :create, params: {  comment: FactoryBot.attributes_for(:comment).except(:body), product_id: @comment.product }
            expect(response).to redirect_to @comment.product
          end
        end
      end
    end

    context "when user is not logged in" do
      it "cannot create comment" do
        expect{
          post :create, params: { comment: FactoryBot.attributes_for(:comment), product_id: @comment.product }
        }.to_not change(Comment,:count)
      end

      it "redirects to root_path" do
        post :create, params: { comment: FactoryBot.attributes_for(:comment), product_id: @comment.product }
        expect(response).to redirect_to @comment.product
      end
    end
  end

  ########################### DELETE ###########################
  ########################## DESTROY ###########################
  describe "DELETE #destroy" do
    context "when user is logged in" do
      context "when user is logged in" do
        before do
          sign_in @user
        end

        it "cannot delete a comment" do
          expect{
            delete :destroy, params: { product_id: @comment.product, id: @comment.id }
          }.to_not change(Comment,:count)
        end

        it "cannot access /destroy and redirects to root_path" do
          delete :destroy, params: { product_id: @comment.product, id: @comment.id }
          expect(assigns(:comment)).to eq @comment
          expect(response).to have_http_status(302)
          expect(response).to redirect_to root_path
        end
      end

      context "when admin is logged in" do
        before do
          sign_in @admin
        end

        it "assigns the requested comment to @comment" do
          delete :destroy, params: { product_id: @comment.product, id: @comment.id }
          expect(assigns(:comment)).to eq @comment
          expect(response).to have_http_status(302)
        end

        it "can delete a comment" do
          expect{
            delete :destroy, params: { product_id: @comment.product, id: @comment.id }
          }.to change(Comment,:count).by(-1)
          expect(response).to redirect_to @comment.product
        end
      end

    end

    context "when user is not logged in" do
      it "cannot delete a comment" do
        expect{
          delete :destroy, params: { product_id: @comment.product, id: @comment.id }
        }.to_not change(Comment,:count)
      end

      it "cannot access /destroy and redirects to root_path" do
        delete :destroy, params: { product_id: @comment.product, id: @comment.id }
        expect(assigns(:comment)).to eq @comment
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
    end
  end

end
