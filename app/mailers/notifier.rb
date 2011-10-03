class Notifier < ActionMailer::Base
  #default :from => "from@example.com"
  def thanks(image)
    @image = image
    @contest = @image.contest
    @contest_config = @contest.get_configs(I18n.locale)
    mail(:to=>[@image.user_email],
      :bcc=>@contest.notifications_receivers_emails.split(','),
      :from=>[@contest.notifications_sender_email],
      :subject=>'Photo Uploaded Successfully')
  end
  
  def abuse(link,contest)
    @contest = contest
    @contest_config = @contest.get_configs(I18n.locale)
    @link = link
    mail(:to=>@contest.notifications_receivers_emails.split(','),
      :from=>[@contest.notifications_sender_email],
      :subject=>'Abuse Email')
  end
  
  def demo(contest)
    @contest = contest
    mail(:to=>@contest.user.email,
      :from=>['N2V <no-reply@n2vrc.com>'],
      :subject=>'Your photo contest ends in 2 days!') do |format|
      format.html {render :layout => 'n2v_mail'}
    end
  end
end
