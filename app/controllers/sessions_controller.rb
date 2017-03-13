class SessionsController < ApplicationController
  layout "user"

  def new
  end

  def create
    user = User.find_by_login(params[:user][:login])
    # If the user exists AND the password entered is correct.
    if user && user.authenticate(params[:user][:password])
      # Save the user id inside the browser cookie. This is how we keep the user 
      # logged in when they navigate around our website.
      session[:user_id] = user.id
      flash[:notice] = "登录成功"
      redirect_to '/accounts'
    else
      flash[:notice] = "用户名密码错误"
    # If user's login doesn't work, send them back to the login form.
      redirect_to '/login'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login'
  end
end