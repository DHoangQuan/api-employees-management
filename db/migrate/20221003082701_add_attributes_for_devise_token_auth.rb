class AddAttributesForDeviseTokenAuth < ActiveRecord::Migration[6.1]
  def change
    ## Required
    add_column :users, :provider, :string, null: false, default: 'email'
    add_column :users, :uid, :string, null: false, default: ''

    ## Recoverable
    add_column :users, :allow_password_change, :boolean, default: false

    ## Confirmable
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string # Only if using reconfirmable

    ## Tokens
    add_column :users, :tokens, :json

    remove_index :users, :email
    remove_index :users, %i[id display_name email phone_number]

    User.where(uid: '').each do |obj|
      obj.update(uid: obj.email)
    end

    add_index :users, %i[uid provider], unique: true
    add_index :users, :email, unique: true
    add_index :users, :confirmation_token, unique: true
    add_index :users, %i[display_name phone_number]
  end
end
