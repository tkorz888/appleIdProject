class AddParentUserIdToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts,:parent_user_id,:integer
  end
end
