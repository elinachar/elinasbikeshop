require 'rails_helper'

describe User do
  context "create new user validation" do

    attrs = FactoryBot.attributes_for(:user).except(:email)

    it "is not valid without an email" do
      @user = User.new(attrs)
      expect(@user).to_not be_valid
    end

    it "is not valid without a valid email" do
      @user = FactoryBot.build(:user, email: "email@")
      expect(@user).to_not be_valid
    end


    it "is not valid without a valid email" do
      @user = FactoryBot.build(:user, email: "@email")
      expect(@user).to_not be_valid
    end

    it "is not valid without a password" do
      @user = User.new(attrs)
      expect(@user).to_not be_valid
    end

    it "is not valid with a short password" do
      @user = FactoryBot.build(:user, password: "12345")
      expect(@user).to_not be_valid
    end

  end

end
