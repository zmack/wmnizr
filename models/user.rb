class User
  include DataMapper::Resource

  property :id, Serial
  property :login, String
  property :crypted_password, String, :length => 60

  validates_is_unique :login

  def self.find_by_login_and_password(login, password)
    user = self.first :conditions => { :login => login }
    user if user.nil? || self.is_valid_password(user.crypted_password, password)
  end

  def password=(value)
    self.crypted_password = User.crypt(value)
  end

private
  def self.crypt(value)
    BCrypt::Password.create(value, :cost => 10)
  end

  def self.is_valid_password(hash, password)
    BCrypt::Password.new(hash) == password
  end
end
