class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_user!
  before_filter :configure_permitted_parameters, if: :devise_controller? or

  protected

  # mixpanel tracking
  TRACKER = ApplicationHelper::EventTracker.new #Mixpanel::Tracker.new("") # 1b32058342e0f05fc3421a7aae5cbdab

  #->Prelang (user_login:devise)
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up)        { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in)        { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end

  # returns one status [novote, dontknow, privilege, notprivilege]
  def get_vote_status(user, email)
    status = ""
    if user.voted_for? email
      if current_user.voted_down_on? email
        weight = Vote.where(votable_id: email.id, voter_id: user.id).first[:vote_weight]
        if weight == 2
          status = "dontknow"
        else
          status = "notprivilege"
        end
      elsif current_user.voted_up_on? email, :vote_weight => 1
        status = "privilege"
      end
    else
      status = "novote"
    end

    status
  end
  helper_method :get_vote_status

  private

  
  #-> Prelang (user_login:devise)
  def require_user_signed_in
    unless user_signed_in?

      # If the user came from a page, we can send them back.  Otherwise, send
      # them to the root path.
      if request.env['HTTP_REFERER']
        fallback_redirect = :back
      elsif defined?(root_path)
        fallback_redirect = root_path
      else
        fallback_redirect = "/"
      end

      redirect_to fallback_redirect, flash: {error: "You must be signed in to view this page."}
    end
  end

end
