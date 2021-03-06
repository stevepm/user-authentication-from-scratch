require 'spec_helper'
require 'capybara/rspec'

Capybara.app = Application


feature 'Homepage' do

  before do
    DB[:users].delete
  end

  scenario 'User can register' do
    visit '/'
    click_on 'Register'
    fill_in 'Email', with: 'joe@example.com'
    fill_in 'Password', with: 'Password'
    fill_in 'Confirm_Password', with: 'Password'
    click_on 'Register'
    expect(page).to have_content 'Welcome, joe@example.com'
    click_on 'Logout'
    click_on 'Register'
    fill_in 'Email', with: 'joe@example.com'
    fill_in 'Password', with: 'Password'
    fill_in 'Confirm_Password', with: 'Password'
    click_on 'Register'
    expect(page).to have_content 'Email address is already taken'

  end

  scenario 'User can logout' do
    visit '/'
    click_on 'Register'
    fill_in 'Email', with: 'joe@example.com'
    fill_in 'Password', with: 'Password'
    fill_in 'Confirm_Password', with: 'Password'
    click_on 'Register'
    click_on 'Logout'
    expect(page).to have_no_content 'Welcome, joe@example.com'
    expect(page).to have_no_content 'Logout'
    expect(page).to have_content 'Register'
    expect(page).to have_content 'Welcome!'
  end
  scenario 'User can login' do
    visit '/'
    click_on 'Register'
    fill_in 'Email', with: 'joe@example.com'
    fill_in 'Password', with: 'Password'
    fill_in 'Confirm_Password', with: 'Password'
    click_on 'Register'
    click_on 'Logout'
    click_on 'Login'
    fill_in 'Email', with: 'joe@example.com'
    fill_in 'Password', with: 'Password'
    click_on 'Login'
    expect(page).to have_content 'Welcome, joe@example.com'
    expect(page).to have_no_content 'Invalid Email/Password'

  end

  scenario 'User can login' do
    visit '/'
    click_on 'Register'
    fill_in 'Email', with: 'joe@example.com'
    fill_in 'Password', with: 'Password'
    fill_in 'Confirm_Password', with: 'Password'
    click_on 'Register'
    click_on 'Logout'
    click_on 'Login'
    fill_in 'Email', with: 'joe momma'
    fill_in 'Password', with: 'Password'
    click_on 'Login'
    expect(page).to have_content 'Invalid Email/Password'
  end

  scenario 'Admin can see view users link' do
    visit '/'
    click_on 'Register'
    fill_in 'Email', with: 'joe@example.com'
    fill_in 'Password', with: 'Password'
    fill_in 'Confirm_Password', with: 'Password'
    click_on 'Register'
    DB[:users].where(:email => 'joe@example.com').update(:admin => true)
    click_on 'Logout'
    click_on 'Login'
    fill_in 'Email', with: 'joe@example.com'
    fill_in 'Password', with: 'Password'
    click_on 'Login'
    expect(page).to have_link 'View all users'
    click_on 'View all users'
    expect(current_url).to eq("http://www.example.com/users")
    expect(page).to have_content 'Users'
  end

  scenario 'Non-admins cannot see or access users page' do
    visit '/'
    click_on 'Register'
    fill_in 'Email', with: 'joe@example.com'
    fill_in 'Password', with: 'Password'
    fill_in 'Confirm_Password', with: 'Password'
    click_on 'Register'
    click_on 'Logout'
    click_on 'Login'
    fill_in 'Email', with: 'joe@example.com'
    fill_in 'Password', with: 'Password'
    click_on 'Login'
    expect(page).to have_no_link 'View all users'
    visit '/users'
    expect(current_url).to eq("http://www.example.com/error")
    expect(page).to have_content 'ERROR: 404'
    click_link 'here'
    expect(current_url).to eq("http://www.example.com/")
  end

  scenario 'Gives error if passwords dont match' do
    visit '/'
    click_on 'Register'
    fill_in 'Email', with: 'joe@example.com'
    fill_in 'Password', with: 'Password'
    fill_in 'Confirm_Password', with: 'other-stuff'
    click_on 'Register'
    expect(page).to have_content 'ERROR: Passwords do not match'
  end

  scenario 'Gives error if password is less than 3 characters' do
    visit '/'
    click_on 'Register'
    fill_in 'Email', with: 'joe@example.com'
    fill_in 'Password', with: 'Pa'
    fill_in 'Confirm_Password', with: 'Pa'
    click_on 'Register'
    expect(page).to have_content 'ERROR: Password must be at least 3 characters'
  end

  scenario 'Gives error if password is blank' do
    visit '/'
    click_on 'Register'
    fill_in 'Email', with: 'joe@example.com'
    fill_in 'Password', with: '   '
    fill_in 'Confirm_Password', with: '   '
    click_on 'Register'
    expect(page).to have_content "ERROR: Password can't be blank"
  end

  scenario 'Gives error if email is not valid' do
    visit '/'
    click_on 'Register'
    fill_in 'Email', with: '   '
    fill_in 'Password', with: 'Password'
    fill_in 'Confirm_Password', with: 'Password'
    click_on 'Register'
    expect(page).to have_content "ERROR: Email can't be blank"
    fill_in 'Email', with: 'evan-tedesco'
    fill_in 'Password', with: 'Password'
    fill_in 'Confirm_Password', with: 'Password'
    click_on 'Register'
    expect(page).to have_content 'ERROR: Email must be valid'
  end
end