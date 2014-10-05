# -*- encoding : utf-8 -*-
require 'digest/sha1'
class Noruser < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  has_and_belongs_to_many :roles
#  acts_as_authorized_user
  attr_accessor :password
#  attr_protected :activated_at

  validate :login, :email, :presence => true
  validate :password, :presence => true, :if => :password_required?
  validate :password_confirmation, :presence => true, :if => :password_required?
#  validates_presence_of     :login, :email
#  validates_presence_of     :password,                   :if => :password_required?
#  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  before_create :make_activation_code
  before_save :encrypt_password
 
  #include NorAuthorize

  def has_role?(role)
      self.roles.each{|r|
        return true if r.name == "Admin"
  #      return true if r.name == role
      }
      return false

    # if self.roles.include?
    #   return true
    # else
    #   return false
    # end
  end


  # Reset passord ting:

  def forgot_password
    @forgotten_password = true
    self.make_password_reset_code
  end

  def reset_password
    # First update the password_reset_code before setting the 
    # reset_password flag to avoid duplicate email notifications.
    update_attributes(:password_reset_code => nil)
    @reset_password = true
  end

  def recently_reset_password?
    @reset_password
  end

  def recently_forgot_password?
    @forgotten_password
  end
   
  # Slutt på passord resett ting (en til under protected)
  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    #    u = find_by_login(login) # need to get the salt
#    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login]
    u = self.where(['login = ? and activated_at IS NOT NULL', login]).take
    u && u.authenticated?(password, u.salt) ? u : nil
  end

  # Activates the user in the database.
  def activate
    @activated = true
    update_attributes(:activated_at => Time.now.utc, :activation_code => nil)
  end
    
  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end
  
  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def Noruser.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def Noruser.encrypt(password, salt)
#    Digest::SHA1.hexdigest(token.to_s)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end
  def Noruser.encryptcookie(password)
    Digest::SHA1.hexdigest(password.to_s)
  end

  def authenticated?(password, salt)
#    crypted_password == Noruser.encrypt(password)
    crypted_password == Noruser.encrypt(password, salt)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end


  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
#    save(false)
  end

  def new_random_password
    self.password= Digest::SHA1.hexdigest("--#{rand.to_s}--#{login}--")[0,6]
    self.password_confirmation = self.password
  end

  protected
  
  # If you're going to use activation, uncomment this too
  def make_activation_code
    self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end
  
  # before filter 
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.crypted_password = encrypt(password)
  end
    
  def password_required?
    crypted_password.blank? || !password.blank?
  end

  def make_password_reset_code
    self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end

  private

    def create_remember_token
      self.remember_token = Noruser.encrypt(Noruser.new_remember_token)
    end

  #  def set_new_password(password)
  #    self.password= password
  #    self.password_confirmation = self.password
  #  end
    
end
