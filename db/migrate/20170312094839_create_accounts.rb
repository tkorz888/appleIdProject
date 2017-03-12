class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :login
      t.string :password
      t.string :mail
      t.string :mailpassword
      t.string :ask1
      t.string :answer1
      t.string :ask2
      t.string :answer2
      t.string :ask3
      t.string :answer3
      t.string :firstname
      t.string :lastname
      t.string :birthday
      t.string :country
      t.integer :state
      t.integer :user_id

      t.timestamps
    end
  end
end
