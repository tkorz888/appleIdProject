class User < ApplicationRecord
  has_secure_password
  validates :login, uniqueness: true, :presence => true
  validates :password_digest, :presence => true
  
end
