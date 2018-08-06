require 'rails_helper'

describe UsersController, type: :controller do

  before do
    @user = FactoryBot.create(:user)
    @admin = FactoryBot.create(:admin)
  end

  ########################### GET ###########################
  ################ INDEX - SHOW -NEW - EDIT #################

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
          expect(response).to redirect_to root_path
        end
      end

      context "when admin is logged in" do
        before do
          sign_in @admin
        end

        it "can access #index" do
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
          expect(response).to have_http_status(302)
          expect(response).to redirect_to root_path
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
          expect(response).to render_template :show
        end
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        get :show, params: { id: @user.id }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  ########################### NEW ###########################
  describe "GET #new" do
    context "when user is logged in" do
      context "when simple user is logged in" do
        before do
          sign_in @user
        end

        it "cannot access /users/new and redirects to root_path" do
          get :new
          expect(response).to have_http_status(302)
          expect(response).to redirect_to root_path
        end
      end

      context "when admin is logged in" do
        before do
          sign_in @admin
        end

        it "can access /users/new" do
          get :new
          expect(response).to render_template :new
        end
      end
    end

    context "when user is not logged in" do
      it "cannot access /users/new and redirects to root_path" do
        get :new
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_user_session_path
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
          expect(response).to redirect_to root_path
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
          expect(response).to render_template :edit
        end
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        get :edit, params: { id: @user.id }
        expect(response).to redirect_to new_user_session_path
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

        it "cannot create user" do
          expect{
            post :create, params: { user: FactoryBot.attributes_for(:user) }
          }.to_not change(User,:count)
        end

        it "redirects to root_path" do
          post :create, params: { user: FactoryBot.attributes_for(:user) }
          expect(response).to redirect_to root_path
        end
      end

      context "when admin is logged in" do
        before do
          sign_in @admin
        end

        context "with valid attributes" do
          it "creates a new user" do
            expect{
              post :create, params: { user: FactoryBot.attributes_for(:user) }
            }.to change(User,:count).by(1)
          end

          it "redirects to the new user" do
            post :create, params: { user: FactoryBot.attributes_for(:user) }
            expect(response).to redirect_to User.last
          end
        end

        context "with invalid attributes" do
          it "does not save the new user without an email" do
            expect{
              post :create, params: { user: FactoryBot.attributes_for(:user).except(:email) }
            }.to_not change(User,:count)
          end

          it "does not save the new user without a password" do
            expect{
              post :create, params: { user: FactoryBot.attributes_for(:user).except(:password) }
            }.to_not change(User,:count)
          end

          it "re-renders the new method" do
            post :create, params: { user: FactoryBot.attributes_for(:user).except(:email) }
            expect(response).to render_template :new
          end
        end
      end
    end

    context "when user is not logged in" do
      it "cannot create user" do
        expect{
          post :create, params: { user: FactoryBot.attributes_for(:user) }
        }.to_not change(User,:count)
      end

      it "redirects to root_path" do
        post :create, params: { user: FactoryBot.attributes_for(:user) }
        expect(response).to redirect_to new_user_session_path
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

        context "changes attributes for @user" do
          it "assigns the requested user to @user" do
            put :update, params: { id: @user.id, user: FactoryBot.attributes_for(:user) }
            expect(assigns(:user)).to eq @user
          end

          it "changes @user's attributes" do
            put :update, params: { id: @user.id, user: FactoryBot.attributes_for(:user, first_name: "Updated first name", last_name: "Updated last name") }
            @user.reload
            expect(@user.first_name).to eq "Updated first name"
            expect(@user.last_name).to eq "Updated last name"
          end

          it "redirects to the updated user" do
            put :update, params: { id: @user.id, user: FactoryBot.attributes_for(:user) }
            expect(response).to redirect_to @user
          end
        end

        context "cannot change attributes for @admin" do
          it "assigns the requested user to @admin" do
            put :update, params: { id: @admin.id, user: FactoryBot.attributes_for(:user) }
            expect(assigns(:user)).to eq @admin
          end

          it "cannot not change @admin's attributes" do
            put :update, params: { id: @admin.id, user: FactoryBot.attributes_for(:user, first_name: "Updated first name", last_name: "Updated last name") }
            @admin.reload
            expect(@admin.first_name).to eq "Admin"
            expect(@admin.last_name).to_not eq "Updated last name"
          end

          it "redirects to root_path" do
            put :update, params: { id: @admin.id, user: FactoryBot.attributes_for(:user) }
            expect(response).to redirect_to root_path
          end
        end
      end

      context "when admin is logged in" do
        before do
          sign_in @admin
        end

        context "changes attributes for @admin" do
          it "assigns the requested user to @admin" do
            put :update, params: { id: @admin.id, user: FactoryBot.attributes_for(:user) }
            expect(assigns(:user)).to eq @admin
          end

          it "changes @admin's attributes" do
            put :update, params: { id: @admin.id, user: FactoryBot.attributes_for(:user, first_name: "Updated first name", last_name: "Updated last name") }
            @admin.reload
            expect(@admin.first_name).to eq "Updated first name"
            expect(@admin.last_name).to eq "Updated last name"
          end

          it "redirects to the updated user" do
            put :update, params: { id: @admin.id, user: FactoryBot.attributes_for(:user) }
            expect(response).to redirect_to @admin
          end
        end

        context "changes attributes for @user" do
          it "assigns the requested user to @user" do
            put :update, params: { id: @user.id, user: FactoryBot.attributes_for(:user) }
            expect(assigns(:user)).to eq @user
          end

          it "changes @user's attributes" do
            put :update, params: { id: @user.id, user: FactoryBot.attributes_for(:user, first_name: "Updated first name", last_name: "Updated last name") }
            @user.reload
            expect(@user.first_name).to eq "Updated first name"
            expect(@user.last_name).to eq "Updated last name"
          end

          it "redirects to the updated user" do
            put :update, params: { id: @user.id, user: FactoryBot.attributes_for(:user) }
            expect(response).to redirect_to @user
          end
        end
      end
    end

    context "when user is not logged in" do
      it "cannot not change @user's attributes" do
        put :update, params: { id: @user.id, user: FactoryBot.attributes_for(:user, first_name: "Updated first name", last_name: "Updated last name") }
        @user.reload
        expect(@user.first_name).to eq "Simple"
        expect(@user.last_name).to_not eq "Updated last name"
      end

      it "redirects to root_path" do
        put :update, params: { id: @user.id, user: FactoryBot.attributes_for(:user) }
        expect(response).to redirect_to new_user_session_path
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

        it "loads correct user details" do
          get :edit, params: { id: @user.id }
          expect(assigns(:user)).to eq @user
          expect(response).to be_ok
        end

        it "can delete himself and redirects to login" do
          expect{
            delete :destroy, params: {id: @user.id}
          }.to change(User,:count).by(-1)
          expect(response).to redirect_to root_path
        end

        it "cannot delete another user" do
          expect{
            delete :destroy, params: {id: @admin.id}
          }.to_not change(User,:count)
        end

        it "cannot access /admin.id" do
          delete :destroy, params: { id: @admin.id}
          expect(assigns(:user)).to eq @admin
          expect(response).to have_http_status(302)
          expect(response).to redirect_to root_path
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

        it "can delete any user and redirects to /users" do
          expect{
            delete :destroy, params: {id: @user.id}
          }.to change(User,:count).by(-1)
          expect(response).to redirect_to users_path
        end

        it "can delete himeself" do
          expect{
            delete :destroy, params: {id: @admin.id}
          }.to change(User,:count).by(-1)
          expect(response).to redirect_to users_path
        end
      end

    end

    context "when user is not logged in" do
      it "cannot delete a user" do
        expect{
          delete :destroy, params: {id: @user.id}
        }.to_not change(User,:count)
      end

      it "cannot access /destroy and redirects to login" do
        delete :destroy, params: { id: @user.id}
        expect(assigns(:user)).to eq @user
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end
