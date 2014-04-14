require 'sinatra/base'
require 'rack-flash'

class Application < Sinatra::Application

  def initialize(app=nil)
    super(app)
  end

  enable :sessions
  use Rack::Flash

  get '/' do
    erb :index, locals: {:email => session[:email]}
  end

  get '/register' do
    error_message = nil
    error_message = flash.now[:registration_error] if flash[:registration_error]
    erb :register, :locals => {:error_message => error_message}
  end

  post '/' do
    email_register = params[:Email_register]
    email_login = params[:Email_login]
    password_register = params[:Password_register]
    password_login = params[:Password_login]
    if email_login && password_login
      if UserRepository.validate_user?(email_login, password_login)
        session[:email] = email_login
        redirect '/'
      else
        flash[:login_error] = 'Invalid Email/Password'
        redirect '/login'
      end
    else
      if UserRepository.email_exists?(email_register)
        flash[:registration_error] = 'Email address is already taken'
        redirect '/register'
      else
        user_email = UserRepository.create(email_register, password_register)
        session[:email] = user_email
        redirect '/'
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
end