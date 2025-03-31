class CreateMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.boolean :owner, default: false

      t.timestamps
    end

    add_index :memberships, [ :user_id, :account_id ], unique: true
  end
end
