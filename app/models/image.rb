class Image < ActiveRecord::Base
  ######################################
  ############ Modules #################
  ######################################  
  include EmailAddressValidation
  include FlagShihTzu
  # number of records per page
  paginates_per 24
  make_voteable
  mount_uploader :image_file, ImageFileUploader
  ######################################
  ############ Associations ############
  ######################################
  belongs_to :contest
  belongs_to :user
  
  ######################################
  ############ Validations #############
  ######################################
  validates :image_file, :presence => true,
    :file_size => { :maximum => 10.megabytes.to_i}
  validates :user_id, :presence => true
  validates :contest_id, :presence => true
  validates :user_name, :presence=>true
  validates :user_email, :presence=>true,:format => { :with => EMAIL_ADDRESS_EXACT_PATTERN }

  ######################################
  ############ Accessibility ###########
  ######################################
  attr_accessible :image_file, :user_name,:user_email
  
  
  ######################################
  ############ Flags ###################
  ######################################    
  has_flags 1 => :won_creative_prize
  
  ######################################
  ############ Scopes ###################
  ###################################### 
  scope :latest, lambda{|contest| where(:contest_id=>contest).order('created_at DESC')}

  ######################################
  ############ Instance methods ########
  ######################################  
  
  # fetch next comic in the same book
  def next_in_contest
    Image.where(["contest_id = ? AND id > ?",self.contest_id,self.id]).order("id ASC").limit(1).first
  end
  
  # fetch the previous comic in the same book
  def previous_in_contest
    Image.where(["contest_id = ? AND id < ?",self.contest_id,self.id]).order("id DESC").limit(1).first
  end
  
    
  def can_be_deleted?(user)
    (self.user.id == user.id) or (self.contest.admin? user)
  end
  
  def first_in_contest
     Image.where(["contest_id = ?",self.contest_id]).order("id ASC").limit(1).first
  end

  def last_in_contest
     Image.where(["contest_id = ?",self.contest_id]).order("id DESC").limit(1).first
  end
  
end
