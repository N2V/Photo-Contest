class HomeController < ApplicationController
  before_filter :require_login!,:except=>[:page]
  
  def app
    redirect_to Contest.first
  end
  
  def index
    redirect_to Contest.first
  end
  
  def page
    # get facebook page params
    page_info = parse_data["page"]
    # set admin specific settings
    set_page_admin_settings(page_info)
    # get the latest contest associated with this page
    @contest = Contest.where(:page_id=>page_info["id"]).last
    # no contest, then make dummy one for layout rendering
    if @contest.nil?
      @contest = Contest.new
      @contest_config = {}
    else
      set_locale
      @contest_config = @contest.get_configs(I18n.locale)
      @images = if @contest.ended?
        @contest.most_voted_results(6)
      else
        Image.latest(@contest).limit(6)
      end
    end
  end
 
  private
  
  def set_page_admin_settings(page_info)
    @can_create_contest = Contest.can_create_contest?(page_info)
    if @can_create_contest
      session[:page_admin] = page_info["admin"]
      session[:page_id] = page_info["id"]
    end
  end
  
end