class AddIndexReportsKeyHostname < ActiveRecord::Migration[6.0]
  def change
    remove_index :reports, :key
    add_index :reports, %w[key hostname], unique: true
  end
end
