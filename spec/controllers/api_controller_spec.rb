require "rails_helper"

describe ApiController,type: :controller do

  describe "GET #index" do

  #   STATES = {
  #   "0" => "初始化",
  #   "1" => "注册成功",
  #   "2" => "注册失败",
  #   "3" => "激活成功",
  #   "4" => "激活失败",
  #   "5" => "待激活",
  #   "6" => "待注册"
  # }
    let!(:user){create(:user)}
    let!(:account_0){create(:account,:state=>0,:user=>user)}
    let!(:account_0_2){create(:account,:state=>0,:user=>user)}
    let!(:account_1){create(:account,:state=>1,:user=>user)}
    let!(:account_2){create(:account,:state=>2,:user=>user)}
    let!(:account_3){create(:account,:state=>3,:user=>user)}
    let!(:account_4){create(:account,:state=>4,:user=>user)}
    let!(:account_5){create(:account,:state=>5,:user=>user)}
    let!(:account_5_2){create(:account,:state=>5,:user=>user)}


    let!(:account_6){create(:account,:state=>6)}
    it "创建新的apple ID" do
     
      process :upload_register_result, method: :post,:params => {:login=> "iamname111",:password=>"aaaaaa",:success=>"yes",:id=>user.id,:secret=>user.secret}
      expect(response).to be_success
      r= JSON.parse(response.body)
      expect(r["code"]).to eq(0)
      expect(r["message"]).to eq("保存成功")
      expect(Account.last.login).to eq("iamname111")
    end
    it "上传邮箱和邮箱密码" do
      process :upload_mail_for_new_account, method: :post,:params => {:mail=> "name",:mailpassword=>"mailpassword",:id=>user.id,:secret=>user.secret}
      r= JSON.parse(response.body)
      expect(r["code"]).to eq(0)
     
    end


    it "获取一个可以用来注册的邮箱" do
      
      get :get_one_mail_to_register, params: {:id=>user.id,:secret=>user.secret}
      r= JSON.parse(response.body)
      expect(r["code"]).to eq(0)
    
      account_0.reload
      expect(account_0.state).to eq(6)

      get :get_one_mail_to_register, params: {:id=>user.id,:secret=>user.secret}
      r= JSON.parse(response.body)
      expect(r["code"]).to eq(0)
      expect(r["message"]).to eq("成功")
      account_0_2.reload
      expect(account_0_2.state).to eq(6)
    end

    it "获取一个可以用来激活的账号" do
      get :get_one_mail_to_activate, params: {:id=>user.id,:secret=>user.secret}
      r= JSON.parse(response.body)
      expect(r["code"]).to eq(0)
      expect(r["message"]).to eq("成功")
      expect(r['account']['login']).to eq(account_5.login)
      
    end


    it "上传激活结果" do
      process :upload_activate_result, method: :post,:params => {:mail=> account_5.mail,:success=>"yes",:id=>user.id,:secret=>user.secret}
      
      r= JSON.parse(response.body)
      expect(r["code"]).to eq(0)
      expect(r["message"]).to eq("保存成功")
      account_5.reload
      expect(account_5.state).to eq(3)

     process :upload_activate_result, method: :post,:params => {:mail=> account_5_2.mail,:success=>"no",:id=>user.id,:secret=>user.secret}
      
      r= JSON.parse(response.body)
      expect(r["code"]).to eq(0)
      expect(r["message"]).to eq("保存成功")
      account_5_2.reload
      expect(account_5_2.state).to eq(4)
    end

   
  end
end

