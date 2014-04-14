require 'bcrypt'

class UserRepository

  class << self
    attr_reader :db

    def attach_db(db)
      @db = db[:users]
    end

    def create(email, password)
      password_hash = BCrypt::Password.create(password)
      db.insert(:email => email, :password_hash => password_hash)
      email
    end

    def find?(email)
      if @db[:email => email]
        new(@db[:email => email])
      else
        false
      end
    end

    def validate_user?(email, password)
      valid = false
      if self.find?(email)
        password_hash = BCrypt::Password.new(self.find?(email).password)
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