class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.string :key, null: false
      t.datetime :date, null: false
      t.string :hostname, null: false
      t.text :description, null: false
      t.string :doc_url
      t.integer :category, null: false
      t.integer :severity, null: false

      t.timestamps
    end
    add_index :reports, :key, unique: true
    add_index :reports, :date
    add_index :reports, :hostname
  end
end
