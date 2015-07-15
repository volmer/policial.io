class CreateUsersRepositories < ActiveRecord::Migration
  def change
    create_join_table :users, :repositories do |t|
      t.index :user_id
      t.index :repository_id
    end
  end
end
