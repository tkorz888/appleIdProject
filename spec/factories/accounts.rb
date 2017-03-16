FactoryGirl.define do
  factory :account do
    sequence :login do |n|
      "login_#{n}"
    end
    password "MyString"
    sequence :mail do |n|
      "mail#{n}@qq.com"
    end
    mailpassword "MyString"
    ask1 "MyString"
    answer1 "MyString"
    ask2 "MyString"
    answer2 "MyString"
    ask3 "MyString"
    answer3 "MyString"
    firstname "MyString"
    lastname "MyString"
    birthday "MyString"
    country "MyString"
    state 1
    user_id 1
  end
end
