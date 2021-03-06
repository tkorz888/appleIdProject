class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  # GET /accounts
  # GET /accounts.json
  def index
    if params[:q].present?
      if params[:q][:state_eq] == '全部'
        params[:q][:state_eq] = nil
      end

      if params[:q][:user_id_eq].to_s == '0'
        params[:q][:user_id_eq] = nil
        params[:q][:parent_user_id_eq] = current_user.id if current_user.root?
      end
    end
    
    @q = Account.ransack(params[:q])
    if params[:commit].to_s.include? "下载"
      @accounts =  @q.result
      send_data @accounts.to_csv,:type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=账号.csv"
    else
       @accounts =  @q.result.paginate(:page => params[:page])
      respond_to do |format|
        format.html {
         
        }
      end
    end
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)

    respond_to do |format|
      if @account.save
        format.html { redirect_to @account, notice: '创建成功.' }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: '更新成功' }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  def import
    if request.post?
      Account.import(params[:account][:file])
      redirect_to accounts_url, notice: "导入成功."
    else
      respond_to do |format|
        format.html {}
        format.json {}
      end
    end
  end

  def batch_download
    @accounts = Account.where(:id=>params[:id])
    respond_to do |format| 
      format.csv {
       send_data @accounts.to_csv, :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=账号.csv"
     }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:login, :password, :mail, :mailpassword, :ask1, :answer1, :ask2, :answer2, :ask3, :answer3, :firstname, :lastname, :birthday, :country, :state, :user_id)
    end
end
