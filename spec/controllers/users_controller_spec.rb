require 'rails_helper'

describe UsersController, type: :controller do
  let(:admin) { User.create!(email: "admin@mail.com", password: "123456", admin: true) }
  let(:simple_user) { User.create!(email: "simple_user@mail.com", password: "123456")}

  ########################### INDEX ###########################
  describe "GET #index" do
    context "when user is logged in" do
      context "when admin is logged in" do
        before do
          sign_in admin
        end

        it "can access #index" do
          get :index
          expect(response).to be_ok
          expect(response).to render_template('index')
        end
      end

      context "when simple_user is logged in" do
        before do
          sign_in simple_user
        end

        it "cannot access #index" do
          get :index
          expect(response).to have_http_status(302)
          expect(response).to redirect_to(root_path)
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

        it "loads correct user details" do
          get :show, params: { id: admin.id }
          expect(response).to be_ok
          expect(assigns(:user)).to eq admin
        end

        it "can access /simple_user.id/show" do
          get :show, params: {id: simple_user.id}
          expect(response).to be_ok
          expect(response).to render_template('show')
          expect(assigns(:user)).to eq simple_user
        end
      end

      context "when simple_user is logged in" do
        before do
          sign_in simple_user
        end

        it "cannot access /admin.id/show" do
          get :show, params: { id: admin.id}
          expect(assigns(:user)).to eq admin
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

  ########################### EDIT ###########################
  describe "GET #edit" do

    context "when user is logged in" do
      context "when admin is logged in" do
        before do
          sign_in admin
        end

        it "loads correct user details" do
          get :edit, params: { id: admin.id }
          expect(response).to be_ok
          expect(assigns(:user)).to eq admin
        end

        it "can access /simple_user.id/edit" do
          get :edit, params: {id: simple_user.id}
          expect(response).to be_ok
          expect(response).to render_template('edit')
          expect(assigns(:user)).to eq simple_user
        end
      end

      context "when simple_user is logged in" do
        before do
          sign_in simple_user
        end

        it "cannot access /admin.id/edit" do
          get :edit, params: { id: admin.id}
          expect(assigns(:user)).to eq admin
          expect(response).to have_http_status(302)
          expect(response).to redirect_to(root_path)
        end
      end

    end

    context "when user is not logged in" do
      it "redirects to login" do
        get :edit, params: { id: admin.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end

  ########################### DELETE ###########################
  describe "DELETE #destroy" do

    context "when user is logged in" do
      context "when admin is logged in" do
        before do
          sign_in admin
        end

        it "loads correct user details" do
          delete :destroy, params: { id: admin.id }
          expect(response).to have_http_status(302)
          expect(assigns(:user)).to eq admin
        end

        it "can access /simple_user.id" do
          delete :destroy, params: {id: simple_user.id}
          expect(response).to have_http_status(302)
          expect(assigns(:user)).to eq simple_user
        end
      end

      context "when simple_user is logged in" do
        before do
          sign_in simple_user
        end

        it "cannot access /admin.id" do
          delete :destroy, params: { id: admin.id}
          expect(assigns(:user)).to eq admin
          expect(response).to have_http_status(302)
          expect(response).to redirect_to(root_path)
        end
      end

    end

    context "when user is not logged in" do
      it "redirects to login" do
        delete :destroy, params: { id: admin.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end

end
