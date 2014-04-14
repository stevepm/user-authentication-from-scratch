require 'spec_helper'
require 'bcrypt'

describe 'User Repository' do

  before do
    DB[:users].delete
  end

  it 'Stores username and password' do
    email = UserRepository.create('joe@example.com', 'password')
    expect(UserRepository.find(email).email).to eq('joe@example.com')
    password_hash = BCrypt::Password.new(UserRepository.find(email).password)
    expect(password_hash).to eq('password')
  end

  it 'returns true if user is in db' do
    email = UserRepository.create('joe@example.com', 'password')
    expect(UserRepository.find(email).email).to eq('joe@example.com')
    expect(UserRepository.email_exists?('joe@hotmail.com')).to eq(false)
  end

  it 'returns nil if email is taken' do
    UserRepository.create('joe@example.com', 'password')
    expect(email = UserRepository.create('joe@example.com', 'password')).to eq(nil)
  end

  it 'validates the user' do
    email = UserRepository.create('joe@example.com', 'password')
    expect(UserRepository.validate_user?(email, 'password')).to eq(true)
    expect(UserRepository.validate_user?(email, 'some_stuff')).to eq(false)
    expect(UserRepository.validate_user?('hotmail', 'some_stuff')).to eq(false)
  end
end