class ContestConfig < ActiveRecord::Base

  ######################################
  ############ Validations #############
  ######################################
  validates :description, :length=>{:maximum=>254},:allow_nil=>true
  
  ######################################
  ############ Accessibility ###########
  ######################################
  attr_accessible :lang,:welcome_note,:upload_hint,:winning_eligibility,:prizes,
    :inappropriate_content,:entry_format,:email_body,:description
 
end
