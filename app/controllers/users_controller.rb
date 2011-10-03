class UsersController < ApplicationController  
  before_filter :require_login!
end