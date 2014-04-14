require 'bcrypt'

class UserRepository

  class << self
    attr_reader :db

    def attach_db(db)
      @db = db[:users]
    end

    def create(email, password)
      password_hash = BCrypt::Password.create(password)
      user_email = nil
      if !self.email_exists?(email)
        db.insert(:email => email, :password_hash => password_hash)
        user_email = email
      end
      user_email
    end

    def email_exists?(email)
      exists = false
      if @db[:email => email]
        exists = true
      end
      exists
    end

    def find(email)
      if self.email_exists?(email)
        new(@db[:email => email])
      else
        nil
      end
    end

    def validate_user?(email, password)
      valid = false
      if self.email_exists?(email)
        password_hash = BCrypt::Password.new(self.find(email).password)
        if password_hash == password
          valid = true
        else
          valid = false
        end
      end

      valid
    end
  end

  attr_accessor :id, :email, :password

  def initialize(user)
    @id = user[:id]
    @email = user[:email]
    @password = user[:password_hash]
  end
end