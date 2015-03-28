class CreateViolations < ActiveRecord::Migration
  def change
    create_table :violations do |t|
      t.string :filename, null: false
      t.integer :line_number, null: false
      t.references :build, index: true, foreign_key: true
      t.text :message, null: false

      t.timestamps null: false
    end
  end
end
