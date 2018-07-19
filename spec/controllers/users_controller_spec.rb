require 'rails_helper'

describe UsersController, type: :controller do
  
  before do
    @user = FactoryBot.create(:user)
    @admin = FactoryBot.create(:admin)
  end

  ########################### INDEX ###########################
  describe "GET #index" do
    context "when user is logged in" do
      context "when user is logged in" do
        before do
          sign_in @user
        end

        it "cannot access #index" do
          get :index
          expect(response).to have_http_status(302)
          expect(response).to redirect_to(root_path)
        end
      end

      context "when admin is logged in" do
        before do
          sign_in @admin
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
      context "when user is logged in" do
        before do
          sign_in @user
        end

        it "loads correct user details" do
          get :show, params: { id: @user.id }
          expect(assigns(:user)).to eq @user
          expect(response).to be_ok
        end

        it "cannot access /admin.id/show" do
          get :show, params: { id: @admin.id}
          expect(assigns(:user)).to eq @admin
          expect(response).to have_http_status(302)
          expect(response).to redirect_to(root_path)
        end
      end

      context "when admin is logged in" do
        before do
          sign_in @admin
        end

        it "can access /user.id/show" do
          get :show, params: {id: @user.id}
          expect(assigns(:user)).to eq @user
          expect(response).to be_ok
          expect(response).to render_template('show')
        end
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        get :show, params: { id: @user.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  ########################### EDIT ###########################
  describe "GET #edit" do
    context "when user is logged in" do
      context "when user is logged in" do
        before do
          sign_in @user
        end

        it "loads correct user details" do
          get :edit, params: { id: @user.id }
          expect(assigns(:user)).to eq @user
          expect(response).to be_ok
        end

        it "cannot access /admin.id/edit" do
          get :edit, params: { id: @admin.id}
          expect(assigns(:user)).to eq @admin
          expect(response).to have_http_status(302)
          expect(response).to redirect_to(root_path)
        end
      end

      context "when admin is logged in" do
        before do
          sign_in @admin
        end

        it "can access /user.id/edit" do
          get :edit, params: {id: @user.id}
          expect(assigns(:user)).to eq @user
          expect(response).to be_ok
          expect(response).to render_template('edit')
        end
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        get :edit, params: { id: @user.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  ########################### DELETE ###########################
  describe "DELETE #destroy" do
    context "when user is logged in" do
      context "when user is logged in" do
        before do
          sign_in @user
        end

        it "loads correct user details" do
          get :edit, params: { id: @user.id }
          expect(assigns(:user)).to eq @user
          expect(response).to be_ok
        end

        it "cannot access /admin.id" do
          delete :destroy, params: { id: @admin.id}
          expect(assigns(:user)).to eq @admin
          expect(response).to have_http_status(302)
          expect(response).to redirect_to(root_path)
        end
      end

      context "when admin is logged in" do
        before do
          sign_in @admin
        end

        it "can access /user.id" do
          delete :destroy, params: {id: @user.id}
          expect(assigns(:user)).to eq @user
          expect(response).to have_http_status(302)
        end
      end

    end

    context "when user is not logged in" do
      it "redirects to login" do
        delete :destroy, params: { id: @user.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

end
