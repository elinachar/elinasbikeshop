require 'rails_helper'

describe UserRegistrationsController, type: :controller do

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  ############################ POST ############################
  ########################### CREATE ###########################
  describe "Post#create" do
    it 'sends welcome message to new signed up user' do
        expect { post :create, params: { user: FactoryBot.attributes_for(:user) } }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
