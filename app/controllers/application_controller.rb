class ApplicationController < ActionController::Base
  #protect_from_forgery
  
  rescue_from Exception, :with => :render_error
  rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
  rescue_from ActionController::RoutingError, :with => :render_not_found
  rescue_from ActionController::UnknownController, :with => :render_not_found
  # customize these as much as you want, ie, different for every error or all the same
  rescue_from ActionController::UnknownAction, :with => :render_not_found
 
  helper_method :liked_page?,:facebook_app_url,:facebook_page_url
 

  def default_url_options(options = nil)
    { :host => "apps.facebook.com/#{APP_CONFIG[:fb_app_name]}" }
  end

  
  # Set path after sign in
  def after_sign_in_path_for(resource)
    session[:return_to] || root_url
  end
  
  # Set path after sign in
  def after_sign_out_path_for(resource)
    session[:return_to] || root_url
  end
  
  def facebook_app_url
    "#{request.scheme}://apps.facebook.com/#{APP_CONFIG[:fb_app_name]}"
  end
  
  def facebook_page_url
    @contest.page_link
  end
  
  # Check if user likes the page
  # If the user is coming from the page itself, then use set flag
  # coming_from_page is true, otherwise use social graph
  def liked_page?(coming_from_page=false)
    if coming_from_page
      signed_data = parse_data
      signed_data["page"].nil? ? false : signed_data["page"]["liked"]
    else
      begin
        client = Koala::Facebook::RestAPI.new(current_user.credentials)
        page_id = @contest.page_id
        results = client.fql_query("SELECT uid FROM page_fan WHERE uid=#{current_user.uid} AND page_id=#{page_id}")
        results.size > 0
        # This might happen with old sessions that didn't get the offline access
        # Best way is to consider him liked the app
      rescue Exception => e
        logger.warn e
        true
      end
    end
  end
  
  protected
  
  
  def parse_data
    # This is a typical set of parameters passed by Facebook
    # Parameters: {"signed_request"=>"vsSe9NNeyqom0hAtGyb2L9scc3-aNbY5Xb25EW55LpE.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImV4cGlyZXMiOjEzMDA3NzAwMDAsImlzc3VlZF9hdCI6MTMwMDc2NDg2Niwib2F1dGhfdG9rZW4iOiIxNzE2MDQwOTI4NjgwNTd8Mi4xQnBWNm5mU2VXRm5RT0lOdzltNWFRX18uMzYwMC4xMzAwNzcwMDAwLTE1MjAwMzkxfEFpNXctc2t4WlJyVUd1ZzZvOU95aDZBQmdSZyIsInVzZXIiOnsiY291bnRyeSI6InVzIiwibG9jYWxlIjoiZW5fVVMiLCJhZ2UiOnsibWluIjoyMX19LCJ1c2VyX2lkIjoiMTUyMDAzOTEifQ"}
    # If we have the signed_request parameters, stash them away
    encoded_user_data = params[:signed_request]
    if encoded_user_data.nil?
      return {}
    else
      # We only care about the data after the '.'
      payload = encoded_user_data.split(".")[1]
      # Facebook gives us a base64URL encoded string. Ruby only supports base64 out of the box, so we have to add padding to make it work
      payload += '=' * (4 - payload.length.modulo(4))
      decoded_json = Base64.decode64(payload)
      return JSON.parse(decoded_json)
    end
  end


 
  def set_locale
    return if @contest.nil?
    languages = @contest.get_languages
    if params[:locale] and languages.include? params[:locale].to_sym
      current_user.update_attribute(:lang,params[:locale]) if current_user
      session[:locale] = params[:locale]
    end
    I18n.locale = if current_user and current_user.lang
      current_user.lang
    elsif session[:locale]
      session[:locale] 
    end
    if I18n.locale.nil? or !languages.include?  I18n.locale
      I18n.locale = @contest.default_language
    end
  end
  
  def require_login!
    if not current_user
      session[:return_to] = "#{facebook_app_url}#{request.fullpath}"
      render :text=> %|<script>window.top.location.href='#{user_omniauth_authorize_path(:facebook)}'</script>|
      return false
    elsif current_user and params[:signed_request] and current_user.uid != parse_data["user_id"]
      #      logger.info current_user.uid
      #      logger.info parse_data["user_id"]
      #      session[:return_to] = "#{facebook_app_url}#{request.fullpath}"
      #      redirect_to destroy_user_session_url
      return true
    end
    true
  end
  
  def render_not_found(exception=nil)
    logger.info exception
    render "errors/status_404", :status => 404
  end
  
  def render_error(exception=nil)
    logger.warn exception
    render "errors/status_500", :status => 500
  end

end
