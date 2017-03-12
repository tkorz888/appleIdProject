class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authorize
    unless current_user
      flash[:notice] = '没登录'
      redirect_to '/login' 
    end
    unless current_user.is_admin?
      flash[:notice] = '没权限'
      redirect_to '/login' 
    end
  end
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "money" && password == "money"
    end
  end
end
