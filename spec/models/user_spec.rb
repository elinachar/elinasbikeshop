require 'rails_helper'

describe User do
  context "create new user validation" do

    it "is not valid without an email" do
      expect(User.new(password: 123456 )).not_to be_valid
    end

    it "is not valid without a valid email" do
      expect(User.new(email: "email@", password: 123456 )).not_to be_valid
    end


    it "is not valid without a valid email" do
      expect(User.new(email: "@email", password: 123456 )).not_to be_valid
    end

    it "is not valid without a password" do
      expect(User.new(email: "email@email.com")).not_to be_valid
    end

    it "is not valid with a short password" do
      expect(User.new(email: "email@email.com", password: 12345)).not_to be_valid
    end

  end

end
