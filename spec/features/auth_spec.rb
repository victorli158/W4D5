require 'spec_helper'
require 'rails_helper'

feature "the signup process" do

  scenario "has a new user page" do
    visit(new_user_url)
    expect(page).to have_current_path(new_user_path)
  end

  feature "signing up a user" do

    scenario "shows username on the homepage after signup" do
      visit(new_user_url)
      fill_in('Email', with: 'stuff@guy.com')
      fill_in('Password', with: 'password')
      click_on('Signup')
      expect(page).to have_current_path(user_path(User.last))
      expect(page).to have_content('stuff@guy.com')
    end

  end

end

feature "logging in" do

  scenario "shows username on the homepage after login" do
    chris = User.create(email: 'chris@fake.com', password: 'password')
    visit(new_session_url)
    fill_in('Email', with: 'chris@fake.com')
    fill_in('Password', with: 'password')
    click_on('Sign-in')
    expect(page).to have_current_path(user_path(chris))
    expect(page).to have_content('chris@fake.com')
  end

end

feature "logging out" do
  let(:chris) { User.create(email: 'chris@fake.com', password: 'password') }

  scenario "begins with a logged out state" do
    visit(user_url(chris))
    expect(page).to have_button('Log in')
  end

  scenario "doesn't show username on the homepage after logout" do
    visit(new_session_url)
    chris
    fill_in('Email', with: 'chris@fake.com')
    fill_in('Password', with: 'password')
    click_on('Sign-in')
    click_on('Log out')
    expect(page).to_not have_content('chris@fake.com')
  end

end
