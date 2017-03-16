require "rails_helper"

describe Product do
 
  context "Factory Girl", :focus => true do
     it "FactoryGirl本身通过验证" do
       product =  FactoryGirl.build(:product)
       expect(product).to be_valid
     end
  end
  