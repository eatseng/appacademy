require 'spec_helper'

describe "the signup process" do

  it "has a new user page" do
    visit new_user_url
    expect(page).to have_content "Sign Up"
  end

  describe "signing up a user" do
    before(:each) do
      visit new_user_url
      fill_in 'email', :with => "user@app.io"
      fill_in 'password', :with => "biscuits"
      click_on "Sign Up"
    end

    it "redirects to goal index page after signup" do
      expect(page).to have_content "Goals Index"
    end

    it "shows username on the homepage after signup" do
      expect(page).to have_content "user@app.io"
    end
  end

  describe "deleting a user" do
    before(:each) do
      visit new_user_url
      fill_in 'email', :with => "user@app.io"
      fill_in 'password', :with => "biscuits"
      click_on "Sign Up"
    end

    it "checks it is on index page" do
      expect(page).to have_content "Goals Index"
    end

    it "checks that a user has been created" do
      expect(page).to have_content "user@app.io"
    end


    it "deletes the user" do
      visit users_url
      click_on "Delete User"
      visit new_session_url
      fill_in 'email', :with => "user@app.io"
      fill_in 'password', :with => "biscuits"
      click_on "Sign In"
      expect(page).to_not have_content "user@app.io"
    end
  end

end