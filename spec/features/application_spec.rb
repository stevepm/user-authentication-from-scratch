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
    click_on 'Register'
    expect(page).to have_content 'Welcome, joe@example.com'
    click_on 'Logout'
    click_on 'Register'
    fill_in 'Email', with: 'joe@example.com'
    fill_in 'Password', with: 'Password'
    click_on 'Register'
    expect(page).to have_content 'Email address is already taken'

  end

  scenario 'User can logout' do
    visit '/'
    click_on 'Register'
    fill_in 'Email', with: 'joe@example.com'
    fill_in 'Password', with: 'Password'
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
    click_on 'Register'
    click_on 'Logout'
    click_on 'Login'
    fill_in 'Email', with: 'joe momma'
    fill_in 'Password', with: 'Password'
    click_on 'Login'
    expect(page).to have_content 'Invalid Email/Password'
  end

end