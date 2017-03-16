FactoryGirl.define do
  factory :user do
    sequence :login do |n|
      "login#{n}"
    end
    
    password "MyString"
    password_confirmation "MyString"
    state 0
    is_admin false
    factory :admin_user do
      after(:create) do |admin|
        admin.is_admin true
      end
    end
  end
end
