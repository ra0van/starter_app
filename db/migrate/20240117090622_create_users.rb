class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string    :username
      t.string    :password_digest
      t.string    :fb_useraccount_id
      t.string    :fb_access_token, limit: 1000
      t.timestamps
    end

    add_index :users, :username, unique: true
  end
end
