require 'spec_helper'

describe "the goal creation/delete process" do
  before(:each) do
    visit new_user_url
    fill_in 'email', :with => "user@app.io"
    fill_in 'password', :with => "biscuits"
    click_on "Sign Up"
  end

  it "has a create goal page" do
    visit new_goal_url
    expect(page).to have_content "Create Goal"
  end


  describe "creating a new goal" do
    before(:each) do
      visit new_goal_url
      fill_in 'body', :with => "complete testing goals app"
      choose "Private"
      click_on "Create Goal"
    end

    it "redirects to goals index page after signup" do
      expect(page).to have_content "Goals Index"
    end

    it "shows new goal on the homepage after signup" do
      expect(page).to have_content "complete testing goals app"
    end
  end


  describe "check goals are private" do
    before(:each) do
      visit new_goal_url
      fill_in 'body', :with => "complete testing goals app"
      click_on "Create Goal"
      click_on "Log Out"

      visit new_user_url
      fill_in 'email', :with => "userX@app.io"
      fill_in 'password', :with => "biscuits"
      click_on "Sign Up"
    end

    it "check that user2 cannot see user1's goals" do
      visit feed_url
      expect(page).to_not have_content "complete testing goals app"
    end
  end


  describe "completing a goal" do
    before(:each) do
      visit new_goal_url
      fill_in 'body', :with => "complete testing goals app"
      choose "Private"
      click_on "Create Goal"
    end

    it "checks it is on index page" do
      expect(page).to have_content "Goals Index"
    end

    it "checks that a goal has been created" do
      expect(page).to have_content "complete testing goals app"
    end

    it "complete the goal" do
      click_on "Goal Completed"
      visit completed_goals_url
      expect(page).to have_content "complete testing goals app"
    end
  end


  describe "deleting a goal" do
    before(:each) do
      visit new_goal_url
      fill_in 'body', :with => "complete testing goals app"
      choose "Private"
      click_on "Create Goal"
    end

    it "checks it is on index page" do
      expect(page).to have_content "Goals Index"
    end

    it "checks that a goal has been created" do
      expect(page).to have_content "complete testing goals app"
    end

    it "deletes the goal" do
      click_on "Delete Goal"
      visit goals_url
      expect(page).to_not have_content "complete testing goals app"
    end
  end
end