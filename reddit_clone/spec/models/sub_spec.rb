require 'spec_helper'

describe Sub do
  describe "should have name and moderator" do
    it "validates presence of name" do
      sub = FactoryGirl.build(:sub, :name => "")
      expect(sub).to have(1).errors_on(:name)
    end

    it "validates presence of moderator" do
      sub = FactoryGirl.build(:sub, :user_id => "")
      expect(sub).to have(1).errors_on(:user_id)
    end
  end

  describe "associations" do

    it { should have_many(:links) }

  end
end
