require 'mail'

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    auth = request.env["omniauth.auth"]

    domain = Mail::Address.new(auth['info']['email']).domain
    # Only allow certain email domains to login
    unless APP_CONFIG['sign_in_email_domains'].include?(domain)
      redirect_to new_user_session_url,
                  flash: { alert: APP_CONFIG['email_domain_restriction_error_message'] }
      return
    end

    @user = User.find_for_google_oauth2(auth, current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.google_data"] = auth
      redirect_to new_user_registration_url
    end
  end
end