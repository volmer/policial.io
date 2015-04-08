class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :name
      t.string :github_token
      t.integer :webhook_id

      t.timestamps null: false
    end
    add_index :repositories, :name, unique: true
  end
end
