require "rails_helper"

describe SimplePagesController, type: :controller do

  context "GET #landing_page" do
    before do
      @products = FactoryBot.create_list(:product, 4)
    end

    it "renders the landing_page template" do
      get :landing_page
      expect(response).to be_ok
      expect(response).to render_template :landing_page
    end

    it "populates an array of the last four products" do
      get :landing_page
      expect(assigns(:products)).to eq @products
    end
  end

  context "GET #index" do
    it "renders the index template" do
      get :index
      expect(response).to be_ok
      expect(response).to render_template :index
    end
  end

  context "GET #about" do
    it "renders the about template" do
      get :about
      expect(response).to be_ok
      expect(response).to render_template :about
    end
  end

  context "GET #contact" do
    it "renders the contact template" do
      get :contact
      expect(response).to be_ok
      expect(response).to render_template :contact
    end
  end

  context "POST #thank_you" do
    it "renders thank_you template" do
      post :thank_you, params: { email: "test@mail.com" }
      expect(response).to render_template :thank_you
    end

    it "sends a confirmation email with valid parameters" do
      expect { post :thank_you, params: { name: "Name", email: "test@mail.com", message: "This is a contact message" } }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

end
