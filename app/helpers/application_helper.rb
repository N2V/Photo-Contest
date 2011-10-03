module ApplicationHelper
  def pageless(total_pages, url, container='results')
    opts = {
      :totalPages => total_pages,
      :url        => url,
      :loaderMsg  => 'Loading more images',
      :loaderImage => '/images/loading.gif'
    }
    
    javascript_tag("$('##{container}').pageless(#{opts.to_json});")
  end

  
  def facebook_comments(image)
    <<doc
<fb:comments href="#{social_link(image)}" num_posts="10" width="500"></fb:comments>
doc
  end
  
  def facebook_send(image)
    <<doc
<fb:send href="#{social_link(image)}" font=""></fb:send>
doc
  end
  
  def facebook_like(image)
    <<doc
<fb:like href="#{social_link(image)}" send="false" layout="button_count" width="200" show_faces="false" font=""></fb:like>
doc
  end
 
 def google_analytics_js
    <<doc 
<script type="text/javascript">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', '#{APP_CONFIG[:google_analytics]}']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>

doc
  end
  
 def app_page?
   params[:controller] == "home" and params[:action] == "page"
 end
 
 def dir
   I18n.locale == :ar ? 'rtl' : 'ltr'
 end
 

 def social_link(image)
   "http://#{request.host}#{social_contest_image_path(image.contest,image)}"
 end
  
end
