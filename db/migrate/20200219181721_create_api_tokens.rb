class CreateApiTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :api_tokens do |t|
      t.string :hostname, null: false
      t.string :token, null: false

      t.timestamps
    end
    add_index :api_tokens, :hostname
    add_index :api_tokens, :token
  end
end
