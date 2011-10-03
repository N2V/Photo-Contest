class ImagesController < ApplicationController
  before_filter :require_login!, :except=>[:social,:do_social]
  before_filter :get_contest,:except=>[:social]
  # GET /images
  # GET /images.xml
  def index
    sort_by = ['recent','votes'].include?(params[:sort]) ? params[:sort] : 'recent'
    order = sort_by == "recent" ? "created_at DESC" : "up_votes DESC"
    @images = Image.where(:contest_id=>@contest).order(order).page(params[:page])
    respond_to do |format|
      format.html {render :layout=>false}
      format.js 
    end
  end

  # GET /images/1
  # GET /images/1.xml
  def show
    @image = Image.find(params[:id])
    @prev = @image.previous_in_contest || @image.last_in_contest
    @next = @image.next_in_contest || @image.first_in_contest
    
    respond_to do |format|
      format.html # show.html.erb
      format.js
    end
  end
  
  # POST /images
  # POST /images.xml
  def create
    redirect_to contest_url(@contest) unless @contest.live?
    @image = Image.new(params[:image])
    @image.user = current_user
    @image.contest = @contest
    respond_to do |format|
      if @image.save
        Notifier.thanks(@image).deliver rescue nil
        format.html { redirect_to([@contest,@image], :notice => t('actionview.image.uploaded')) }
      else
        @tab = 2
        format.html { render :action => 'contests/show' }
      end
    end
  end


  def destroy
    @image = Image.find(params[:id])
    redirect_to contest_url(@contest) unless @image.can_be_deleted?(current_user)
    @image.destroy
    to = if @contest.user_images(current_user).size > 0
      contest_url(@contest,:tab=>'my_photos')
    else
      contest_url(@contest)
    end
    redirect_to to,:notice =>  t('actionview.image.deleted')
  end
  
  def vote
    redirect_to contest_url(@contest) unless @contest.live?
    respond_to do |format|
      format.js  do
        begin
          image = Image.find(params[:id])
          current_user.up_vote(image)
          render :text=>'Success'         
        rescue Exception => e
          logger.warn e
          render :text=>'Failure',:status => :unprocessable_entity 
        end
      end
    end
  end
  
  def mark_as_won
    redirect_to contest_url(@contest) if not(@contest.ended? and @contest.admin?(current_user))
    @image = Image.find(params[:id])
    @image.won_creative_prize = !@image.won_creative_prize?
    @image.save
    redirect_to [@contest,@image],:notice =>  t('actionview.image.updated')
  end
 
  def my
    respond_to do |format|
      format.html {render :layout=>false}
      format.js 
    end
  end
  
  def social
    redirect_to "#{request.scheme}://#{request.host}/contests/#{params[:contest_id]}/images/#{params[:id]}/do_social"
  end
  
  def do_social
    @image = Image.find(params[:id])
    respond_to do |format|
      format.html  {render :layout=>false}
    end
  end
  
  private
  def get_contest
    @contest = Contest.find(params[:contest_id])
    set_locale
    @contest_config = @contest.get_configs(I18n.locale)
  end
end