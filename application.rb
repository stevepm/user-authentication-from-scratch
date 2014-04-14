require 'sinatra/base'
require 'bcrypt'
require 'rack-flash'

class Application < Sinatra::Application

  def initialize(app=nil)
    super(app)

    # initialize any other instance variables for you
    # application below this comment. One example would be repositories
    # to store things in a database.

  end

  enable :sessions
  use Rack::Flash

  get '/' do
    error_message = nil
    error_message = flash[:error].now if flash[:error]
    session[:email] = nil unless session[:email]
    erb :index, locals: {:email => session[:email], :error_message => error_message}
  end

  get '/register' do
    erb :register
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
      user_email = UserRepository.create(email_register, password_register)
      session[:email] = user_email
      redirect '/'
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