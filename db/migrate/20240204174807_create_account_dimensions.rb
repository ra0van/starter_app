class CreateAccountDimensions < ActiveRecord::Migration[7.1]
  def change
    create_table :account_dimensions, :id => false, primary_key: :id do |t|
      t.string        :id, null: false
      t.string        :name
      t.string        :currency
      t.datetime      :stop_date
      t.belongs_to    :users
      t.timestamps

      t.index :id, unique: true
    end
  end
end
