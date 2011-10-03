class User < ActiveRecord::Base
  
  
  ######################################
  ############ Modules ########EEEEE####
  ######################################
  include FlagShihTzu
  make_voter
  
  ######################################
  ############ Associations ############
  ######################################
  has_many :contests
  has_many :images, :order => 'created_at DESC'
  
  ######################################
  ############ Validations #############
  ######################################
  validates :uid, :presence=> true,:uniqueness => true
  
  ######################################
  ############ Accessibility ###########
  ######################################
  attr_accessible :email, :password, :password_confirmation, :uid,:credentials
  
  ######################################
  ############ Flags ###################
  ######################################  
  has_flags 1 => :used_before
  
  ######################################
  ############ Devise ##################
  ######################################  
  devise :database_authenticatable, :rememberable,
    :trackable, :validatable,:omniauthable

  
  ######################################
  ############ Instance methods ########
  ######################################    
  def is_admin?
    email == "admin@n2v.com"
  end
  
 

end
