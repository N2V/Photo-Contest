class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_filter :set_auth
 
  
  def facebook
    user_data = {
      :uid         => @auth['uid'],
      :email       => @auth['extra']['user_hash']['email'],
      :credentials => @auth['credentials']['token']
    }
    session[:name] = @auth['user_info']['name']
    user = User.find_by_uid(user_data[:uid])  
    # User exists
    if user
      user.update_attributes(user_data)
      sign_in_and_redirect user  
    else # First time in system
      user = User.new user_data.merge(:password => Devise.friendly_token[0,20])
      if user.save
        # Post on wall first time use
        begin
#          graph = Koala::Facebook::GraphAPI.new(user.credentials)
#          me = graph.get_object("me")
#          graph.put_wall_post("#{me["name"]} #{t('actionview.facebook.joined')}",
#            :name => t('views.shared.n2v_title'), 
#            :link => facebook_app_url,
#            :caption=> t('views.shared.n2v_by'),
#            :description => t('views.shared.n2v_description'),
#            :picture=>view_context.image_path("logo.jpg"))
        rescue Exception => e
          logger.warn e
        end
        sign_in_and_redirect user
      else
        redirect_to app_url
      end
    end
    
  end
 
 
  def set_auth
    @auth = env['omniauth.auth']
  end
end