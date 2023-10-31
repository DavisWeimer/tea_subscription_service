class RecreateSubscriptionsTable < ActiveRecord::Migration[7.0]
  def up
    drop_table :subscriptions

    create_table :subscriptions do |t|
      t.string :title
      t.float :price
      t.integer :frequency
      t.belongs_to :customer, null: false, foreign_key: true
      t.belongs_to :tea, null: false, foreign_key: true
      t.integer :status, default: 0
      t.timestamps
    end
  end

  def down
    drop_table :subscriptions
  end
end
