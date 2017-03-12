class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :login
      t.string :password_digest
      t.integer :state,:default=>0
      t.integer :is_admin,:default=>0
      
      t.timestamps
    end
  end
end
