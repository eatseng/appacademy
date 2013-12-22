require 'spec_helper'

describe User do
  context "with password" do

    it "does not store password" do
      FactoryGirl.create(:user)
      User.first.password.should be_nil
    end
  end

end
