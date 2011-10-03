class ContestsController < ApplicationController
  before_filter :require_login!
  before_filter :get_contest,:except=>[:new]
  
  def show
    @image = Image.new
    set_tab
  end
  
  def update
    redirect_to contest_url(@contest) unless @contest.admin?(current_user)
    # Make sure some language is selected
    if @contest.update_attributes(params[:contest])
      upload_images_to_s3
      redirect_to contest_url(@contest),:notice =>  t('actionview.contest.updated')
    else
      @tab = 5
      @image = Image.new
      #if the user removed all admins, then restore them.
      @contest.admins = Contest.find(@contest.id).admins if @contest.admins.blank?
      render :action => 'contests/show' 
    end
  end
  
  def new
    redirect_to root_url and return unless Contest.can_create_contest?({'id'=>session[:page_id],'admin'=>session[:page_admin]})
    graph = Koala::Facebook::GraphAPI.new
    page = graph.get_object(session[:page_id])
    @contest = current_user.contests.build :name => 'Photo Contest',
      :page_id => page['id'], :page_link => page['link'], :start_date => Date.today, 
      :end_date => Date.today+7, :admins => current_user.uid, :english => true, 
      :default_language =>'en'
    @contest.demo = true
    @contest.save
    upload_default_images
    render :text=> %|<script>window.top.location.href='#{contest_url(@contest,:tab=>'settings')}'</script>|
  end
  
  def abuse
    @link = params[:link]
    Notifier.abuse(@link,@contest).deliver rescue nil
    render :text=> "Success"
  end
  
  private
  
  def get_contest
    @contest = Contest.find(params[:id])
    set_locale
    @contest_config = @contest.get_configs(I18n.locale)
  end

  
  def set_tab
    case params[:tab]  
    when "my_photos"
      @tab = 3
    when "settings"
      @tab = 5
    else
      #show the images tab if the user used the app before
      if current_user.used_before?
        @tab = @contest.ended? ? 2 : 1
      else # Show the welcome tab upon user's first use of the app
        @tab = 0
        current_user.used_before = true
        current_user.save
      end
    end

  end
  
  
  def upload_images_to_s3
    storage = Fog::Storage.new(:provider => 'AWS',
      :region  =>APP_CONFIG[:s3_region],
      :aws_access_key_id => APP_CONFIG[:s3_access_key_id] , 
      :aws_secret_access_key => APP_CONFIG[:s3_secret_access_key]
    )

    directory =  storage.directories.get(APP_CONFIG[:s3_bucket])
    
    {"0"=>"ar","1"=>"en"}.each do |index,lang|
    
      if params[:contest][:contest_configs_attributes][index][:header_image]
        directory.files.create(:key => "images/contests/#{@contest.id}/#{lang}/header.gif",
          :body => params[:contest][:contest_configs_attributes][index][:header_image],
          :public=>true)
      end
      if params[:contest][:contest_configs_attributes][index][:non_fan_image]
        directory.files.create(:key => "images/contests/#{@contest.id}/#{lang}/non_fan.gif",
          :body => params[:contest][:contest_configs_attributes][index][:non_fan_image],
          :public=>true)
      end
      if params[:contest][:contest_configs_attributes][index][:fan_image]
        directory.files.create(:key => "images/contests/#{@contest.id}/#{lang}/fan.gif",
          :body => params[:contest][:contest_configs_attributes][index][:fan_image],
          :public=>true)
      end
      if params[:contest][:contest_configs_attributes][index][:email_header_image]
        directory.files.create(:key => "images/contests/#{@contest.id}/#{lang}/email_header.gif",
          :body => params[:contest][:contest_configs_attributes][index][:email_header_image],
          :public=>true)
      end
    end
  end
  
  def upload_default_images
    storage = Fog::Storage.new(:provider => 'AWS',
      :region  =>APP_CONFIG[:s3_region],
      :aws_access_key_id => APP_CONFIG[:s3_access_key_id] , 
      :aws_secret_access_key => APP_CONFIG[:s3_secret_access_key]
    )

    directory =  storage.directories.get(APP_CONFIG[:s3_bucket])
       cur_dir = File.dirname(File.dirname(__FILE__))
    ['ar','en'].each do |lang|
      directory.files.create(:key => "images/contests/#{@contest.id}/#{lang}/header.gif",
        :body => File.open("#{cur_dir}/../public/images/default_header.gif"),
        :public=>true)

      directory.files.create(:key => "images/contests/#{@contest.id}/#{lang}/non_fan.gif",
        :body => File.open("#{cur_dir}/../public/images/default_non_fan.gif"),
        :public=>true)
   
      directory.files.create(:key => "images/contests/#{@contest.id}/#{lang}/fan.gif",
        :body => File.open("#{cur_dir}/../public/images/default_fan.gif"),
        :public=>true)
    
      directory.files.create(:key => "images/contests/#{@contest.id}/#{lang}/email_header.gif",
        :body => File.open("#{cur_dir}/../public/images/default_email_header.gif"),
        :public=>true)
    end
  end
  
end

