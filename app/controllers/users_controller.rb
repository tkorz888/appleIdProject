class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  #before_action :authorize,:except=>[:new]
 
  # GET /users
  # GET /users.json
  def index
    @users = User.paginate(:page=>params[:page],:per_page=>1)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    if params[:user_id].present?
      @invi_user = User.find_by_id(params[:user_id])
      @user = User.new
      render :layout=>"user"
    else
      render :plain=>"出错了"
    end
    
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if params[:parent_id].present?
      @user.parent = User.find_by_id(params[:parent_id])
    end
    respond_to do |format|
      if @user.save
        format.html { redirect_to "/login", notice: '注册成功，去登录吧' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
      
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:login,:password,:password_confirmation,:parent_id)
    end
    
    def admin_user_params
      params.require(:user).permit(:login, :password_digest, :state, :is_admin,:password,:password_confirmation,:parent_id)
    end
end
