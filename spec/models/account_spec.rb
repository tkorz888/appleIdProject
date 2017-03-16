require "rails_helper"

describe Account do
  context "Factory Girl", :focus => true do
     it "FactoryGirl本身通过验证" do
       account =  FactoryGirl.build(:account)
       expect(account).to be_valid
     end
  end
  context "创建后,parent_user_id为nil", :focus => true do
     it "FactoryGirl本身通过验证" do
       account =  FactoryGirl.build(:account)
       user =  FactoryGirl.build(:user)
       account.user = user
       account.save
       account.reload
       expect(account.parent_user_id).to eq user.id
     end
  end
  context "创建后,parent_user_id为用户的父用户的id", :focus => true do
     it "FactoryGirl本身通过验证" do
       account =  FactoryGirl.build(:account)
       user1 =  FactoryGirl.build(:user)
       user2 =  FactoryGirl.build(:user)
       user1.save
       user2.parent = user1
       user2.save
       account.user = user2
       account.save
       account.reload
       expect(account.parent_user_id).to eq user1.id
     end
  end
end