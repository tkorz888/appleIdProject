class User < ApplicationRecord
  has_secure_password
  validates :login, uniqueness: true, :presence => true
  validates :secret, uniqueness: true
  validates :password_digest, :presence => true
  has_many :accounts
  has_ancestry
  after_create :generate_secret
  
  def generate_secret
    if self.secret.blank?
      self.secret =  SecureRandom.hex(30)
      self.save
    end
  end

  STATES = {
    "0" => "正常" ,
    "1" => "封号"
  }
  
  def collection_data
    [["全部",0],[self.login,self.id]]+self.children.collect{|c| [c.login,c.id]}
  end
  def self.states
    STATES
  end
 
  def state_to_s
    STATES[self.state.to_s]
  end
end
