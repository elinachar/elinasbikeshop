require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do

  before do
    @product = FactoryBot.create(:product)
    @user = FactoryBot.create(:user)
  end

  describe "POST #create" do
    context "when user is logged in" do
      before do
        sign_in @user
      end

      context "with valid parameters" do
        it "creates an order" do
          expect{ post :create, params: { product_id: @product.id, user: @user, stripeToken: StripeMock.generate_card_token, stripeEmail: "test@mail.com" }
            }.to change(Order,:count).by(1)
        end

        it "redirect to payments/create" do
          post :create, params: { product_id: @product.id, user: @user, stripeToken: StripeMock.generate_card_token, stripeEmail: "test@mail.com" }
          expect(response).to render_template :create
        end

        it "sends an order confirmation email" do
          expect { post :create, params: { product_id: @product.id, user: @user, stripeToken: StripeMock.generate_card_token, stripeEmail: "test@mail.com" }
            }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end
      end

      context "with invalid parameters: card_declined" do
        it "does not create an order" do
          expect{ post :create, params: { product_id: @product.id, user: @user, stripeToken: StripeMock.prepare_card_error(:card_declined), stripeEmail: "test@mail.com" }
            }.to_not change(Order,:count)
        end

        it "does not sends a confirmation email" do
          expect { post :create, params: { product_id: @product.id, user: @user, stripeToken: StripeMock.prepare_card_error(:card_declined), stripeEmail: "test@mail.com" }
            }.to_not change { ActionMailer::Base.deliveries.count }
        end

        it "redirects to product page" do
          post :create, params: { product_id: @product.id, user: @user, stripeToken: StripeMock.prepare_card_error(:card_declined), stripeEmail: "test@mail.com" }
          expect(response).to redirect_to @product
        end
      end
    end

    context "when user is not logged in" do
      context "with valid parameters" do
        it "creates an order" do
          expect{ post :create, params: { product_id: @product.id, stripeToken: StripeMock.generate_card_token, stripeEmail: "test@mail.com" }
            }.to change(Order,:count).by(1)
        end

        it "creates an user" do
          expect{ post :create, params: { product_id: @product.id, stripeToken: StripeMock.generate_card_token, stripeEmail: "test@mail.com" }
            }.to change(User,:count).by(1)
        end

        it "redirect to payments/create" do
          post :create, params: { product_id: @product.id, stripeToken: StripeMock.generate_card_token, stripeEmail: "test@mail.com" }
          expect(response).to render_template :create
        end

        it "sends an order confirmation email" do
          expect { post :create, params: { product_id: @product.id, stripeToken: StripeMock.generate_card_token, stripeEmail: "test@mail.com" }
            }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end
      end

      context "with invalid parameters: existing email" do
        it "does ncreates an order" do
          expect{ post :create, params: { product_id: @product.id, stripeToken: StripeMock.generate_card_token, stripeEmail: @user.email }
            }.to_not change(Order,:count)
        end

        it "does not create an user" do
          expect{ post :create, params: { product_id: @product.id, stripeToken: StripeMock.generate_card_token, stripeEmail: @user.email }
            }.to_not change(User,:count)
        end

        it "redirects to product pate" do
          post :create, params: { product_id: @product.id, stripeToken: StripeMock.generate_card_token, stripeEmail: @user.email}
          expect(response).to redirect_to @product
        end

        it "does not send an order confirmation email" do
          expect { post :create, params: { product_id: @product.id, stripeToken: StripeMock.generate_card_token, stripeEmail: @user.email }
            }.to_not change { ActionMailer::Base.deliveries.count }
        end
      end
    end
  end
end
