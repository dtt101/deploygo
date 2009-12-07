class UserMailer < ActionMailer::Base
  
  def forgot_password(user, sent_at = Time.now)
    subject    'deploygo.com - Reset password'
    recipients user.email
    from       'deploygo@googlemail.com'
    sent_on    sent_at
    body       :user => user, :url => "http://www.deploygo.com/home/reset_password/#{user.reset_password_code}"
  end

end
