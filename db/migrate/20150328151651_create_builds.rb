class CreateBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.integer :pull_request, null: false
      t.string :repo, null: false
      t.string :user, null: false
      t.string :sha, null: false
      t.integer :state, default: 0
      t.text :payload, null: false

      t.timestamps null: false
    end
  end
end
