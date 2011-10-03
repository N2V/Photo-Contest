class Contest < ActiveRecord::Base
  ######################################
  ############ Modules ############
  ######################################
  include AASM
  include FlagShihTzu
  ######################################
  ############ Associations ############
  ######################################
  belongs_to :user
  has_many :contest_configs,:order => 'created_at ASC'
  has_many :images
  
  
  ######################################
  ############ validations #############
  ######################################
  validates :user_id, :presence => true
  validates :page_id, :presence => true  
  validates :languages, :presence => true,:inclusion=>[1,2,3] 
  validates :default_language,:presence=>true,:inclusion=>['en','ar']
  validates :name, :length=>{:minimum=>3,:maximum=>40}
  validates :start_date,  :presence=>true
  validates :end_date,  :presence=>true
  validates :admins,:length=>{:minimum=>3}
  validates :prizes_num,:numericality=>{:only_integer=>true}
  
  
  ######################################
  ############ accessibility ###########
  ######################################
  attr_accessible :name,:page_id,:page_link,:admins,:notifications_email,
    :start_date,:end_date,:prizes_num,:notifications_bcc_emails, :english,
    :arabic, :default_language, :contest_configs_attributes
  accepts_nested_attributes_for :contest_configs
  
 
  ######################################
  ############ Flags ###################
  ######################################  
  has_flags 1 => :english, 2=> :arabic,:column => 'languages'
  has_flags 1 => :demo,:column => 'flags'
  
  
  ######################################
  ############ Scopes ##################
  ######################################
  scope :active, where(:active=>true)
  
  
  ######################################
  ############ State Machine ###########
  ######################################
  aasm_column :state

  aasm_initial_state :live

  aasm_state :live
  aasm_state :paused
  aasm_state :ended

  aasm_event :demo_expired do
    transitions :to => :paused, :from => [:live]
  end
  
  aasm_event :paid do
    transitions :to => :live, :from => [:paused],:exit => :set_paid
  end 
  
  aasm_event :close do
    transitions :to => :ended, :from => [:live,:paused]
  end
  
  ######################################
  ############ Class methods ###########
  ######################################
  def self.close_done
    Contest.live.where("CURDATE() > end_date").all.each do |c|
      c.close
      c.save
    end
  end
  
  def self.pause_demo
    Contest.live.demo.where("CURDATE() > end_date").all.each do |c|
      c.demo_expired
      c.save
    end
  end
  
  def self.notify_demo_owner
    Contest.live.demo.where("CURDATE() = end_date - 2").all.each do |c|
      Notifier.demo(c).deliver rescue nil
    end
  end
  
  def self.can_create_contest?(page_info)
    contest = Contest.where(:page_id => page_info["id"]).last
    (contest.nil?) or (contest.ended? and page_info["admin"])  
  end
  
  ######################################
  ############ Instance methods ########
  ######################################  
  
  def admin?(user)
    admins.split(',').include? user.uid
  end
  
  
  def get_configs(locale)
    c = contest_configs.where(:lang=>locale).first
    c.nil? ?  {} : c.attributes
  end
  
  def user_images(user)
    images.where("user_id=?",user.id).order('created_at DESC')
  end
  
  def most_voted_results(num=nil)
    limit = num||prizes_num
    images.order("up_votes DESC").limit(limit > prizes_num ? prizes_num : limit  )
  end
  
  def creative_results
    images.won_creative_prize
  end
  
  def get_languages
    res = []
    res << :ar if self.arabic?
    res << :en if self.english?
    res
  end
  
  def set_paid
    self.demo = false
    self.save
  end
 
end