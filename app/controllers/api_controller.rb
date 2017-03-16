class ApiController < ApplicationController
  protect_from_forgery except: [:get_task,:upload_task,:update_account]
  before_action :check_secret
  
  def check_secret
    unless User.where(:id=>params[:id],:secret=>params[:secret]).count == 1
      render :json=>{:code=>-1,:message=>"secret 不对"}
    end
  
  end



  def update_account
    # login state
    account = Account.find_by_login(params["login"])
    account.state = params[:state].to_i if (0..4).to_a.include?(params[:state].to_i)
    if account.save
      render :json=>{:code=>0,:message=>"保存成功，状态为 #{account.state_to_s}"}
    else
      render :json=>{:code=>-1,:message=>"保存失败"}
    end
  end

  
  # # 上传创建邮箱
  def upload_mail_for_new_account
    # give me email and emailpassword
    @new_account = Account.find_or_create_by(:mail=>params[:mail])
    @new_account.mailpassword = params[:mailpassword]
    @new_account.user_id = params[:id]
    if @new_account.save
      render :json=>{:code=>0,:message=>"保存成功"}
    else
      render :json=>{:code=>-1,:message=>"保存失败"}
    end
  end

  # 获取一个可用邮箱，去注册apple ID
  def get_one_mail_to_register
    @new_account = Account.pick_one_pending_account(params[:id])
    if @new_account.present?
      render :json=>{:code=>0,:message=>"成功",:account=>@new_account.as_json}
    else
      render :json=>{:code=>1,:message=>"没有可用来注册的邮箱",:account=>@new_account.as_json}
    end
  end
  


  # 反馈注册appleID结果
  def upload_register_result
    if params[:account].present?
      params[:login] = params[:account]
      params[:mail] = params[:account]
      params[:success] = "yes"
    end
    @new_account = Account.find_or_create_by(:mail=>params[:mail])
    if params[:success] == "yes"
      @new_account.state =  1
      @new_account.login  = params[:login] || params[:mail]
      @new_account.password = params[:password] if params[:password].present?
      @new_account.mailpassword = params[:mailpassword] if params[:mailpassword].present?
      @new_account.ask1 = params[:ask1] if params[:ask1].present?
      @new_account.answer1 = params[:answer1] if params[:answer1].present?
      @new_account.ask2 = params[:ask2] if params[:ask2].present?
      @new_account.answer2 = params[:answer2] if params[:answer2].present?
      @new_account.ask3 = params[:ask3] if params[:ask3].present?
      @new_account.answer3 = params[:answer3] if params[:answer3].present?
      @new_account.firstname = params[:firstname] if params[:firstname].present?
      @new_account.lastname = params[:lastname] if params[:lastname].present?
      @new_account.birthday = params[:birthday] if params[:birthday].present?
      @new_account.country = params[:country] if params[:country].present?
      @new_account.user_id = params[:id] || 1
    else
      @new_account.state = 2
    end
    if @new_account.save
      render :json=>{:code=>0,:message=>"保存成功"}
    else
      render :json=>{:code=>-1,:message=>"保存失败"}
    end
  end


  # 获取一个待激活的邮箱，密码和激活URL
  def get_one_mail_to_activate
    @new_account = Account.pick_one_waiting_activate_account(params[:id])
    if @new_account.present?
      render :json=>{:code=>0,:message=>"成功",:account=>@new_account.as_json}
    else
      render :json=>{:code=>-1,:message=>"没有待激活的邮箱",:account=>@new_account.as_json}
    end
  end

  # 上传激活结果
  def upload_activate_result

    if params[:account].present?
      params[:mail] = params[:account]
      params[:success] = "yes"
    end
    @new_account = Account.find_by(:mail=>params[:mail])
    if params[:success].to_s == "yes"
      @new_account.state = 3
    else
      @new_account.state = 4
    end
    if @new_account.save
      render :json=>{:code=>0,:message=>"保存成功"}
    else
      render :json=>{:code=>-1,:message=>"保存失败"}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit!
    end
end