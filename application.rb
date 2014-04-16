require 'sinatra/base'
require 'rack-flash'

class Application < Sinatra::Application

  def initialize(app=nil)
    super(app)
  end

  enable :sessions
  use Rack::Flash

  before do
    if session[:email]
      session[:admin] = UserRepository.find(session[:email]).admin
    end
  end

  helpers do
    def h(text)
      Rack::Utils.escape_html(text)
    end
  end

  get '/' do
    erb :index, locals: {:email => session[:email], :admin => session[:admin]}
  end

  get '/register' do
    error_message = nil
    error_message = flash.now[:registration_error] if flash[:registration_error]
    erb :register, :locals => {:error_message => error_message}
  end

  post '/register' do
    email_register = h(params[:Email_register])
    password_register = h(params[:Password_register])
    confirm_password = h(params[:Confirm_Password])
    if validate_password?(password_register, confirm_password) && validate_email?(email_register)
      if UserRepository.email_exists?(email_register)
        flash[:registration_error] = 'Email address is already taken'
        redirect '/register'
      else
        user_email = UserRepository.create(email_register, password_register)
        session[:email] = user_email
        redirect '/'
      end
    else
      redirect '/register'
    end
  end

  post '/login' do
    email_login = h(params[:Email_login])
    password_login = h(params[:Password_login])
    if email_login && password_login
      if UserRepository.validate_user?(email_login, password_login)
        session[:email] = email_login
        redirect '/'
      else
        flash[:login_error] = 'Invalid Email/Password'
        redirect '/login'
      end
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/login' do
    error_message = nil
    error_message = flash.now[:login_error] if flash[:login_error]
    erb :login, :locals => {:error_message => error_message}
  end

  get '/users' do
    if session[:admin]
      users = UserRepository.list_users
      email = session[:email]
      erb :users, locals: {:users => users, :email => email}
    else
      redirect '/error'
    end
  end

  get '/error' do
    erb :error
  end

  not_found do
    redirect '/error'
  end

  def validate_password?(password, pwd_confirm)
    valid = false
    if password.strip.empty?
      flash[:registration_error] = "ERROR: Password can't be blank"
    elsif password.length < 3
      flash[:registration_error] = 'ERROR: Password must be at least 3 characters'
    elsif password != pwd_confirm
      flash[:registration_error] = 'ERROR: Passwords do not match'
    else
      valid = true
    end
    valid
  end

  def validate_email?(email)
    valid = false
    if email.strip.empty?
      flash[:registration_error] = "ERROR: Email can't be blank"
    elsif (email =~ /^(\w\.*)+[@](\w)+\.([a-zA-Z]{2,6})$/) == nil
      flash[:registration_error] = 'ERROR: Email must be valid'
    else
      valid = true
    end

    valid
  end
end
