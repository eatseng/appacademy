require 'spec_helper'

describe "Cheering" do
  before(:each) do
    visit new_user_url
    fill_in 'email', :with => "user1@app.io"
    fill_in 'password', :with => "biscuits"
    click_on "Sign Up"

    visit new_goal_url
    fill_in 'body', :with => "complete testing goals app"
    choose "Public"
    click_on "Create Goal"
    click_on "Log Out"

    visit new_user_url
    fill_in 'email', :with => "user2@app.io"
    fill_in 'password', :with => "biscuits"
    click_on "Sign Up"
  end

  it "has a create goal page" do
    visit new_goal_url
    expect(page).to have_content "Create Goal"
  end

  it "has user1's goal on feed" do
    visit feed_url
    expect(page).to have_content "complete testing goals app"
  end

  describe "Cheering on a goal" do
    before(:each) do
      visit feed_url
    end

    it "on the goals feed page" do
      expect(page).to have_content "Feed Index"
    end

    it "cheer other people's goal" do
      click_on "Cheer On"
      click_on "Cheer On"
      expect(page).to have_content "2"
    end
  end

  describe "Limited number of cheers a day" do
    before(:each) do
      visit feed_url
    end

    it "on the goals feed page" do
      expect(page).to have_content "Feed Index"
    end

    it "cheer other people's goal" do
      click_on "Cheer On"
      click_on "Cheer On"
      expect(page).to have_content "2"
    end

    it "No more than 5 cheers" do
      8.times {click_on "Cheer On"}
      expect(page).to have_content "5"
    end
  end
end