class AddMissingAttrinbutesToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :first_name, :string, null: false
    add_column :users, :middle_name, :string
    add_column :users, :last_name, :string, null: false
    add_column :users, :phone_number, :string
    add_column :users, :title, :string
    add_column :users, :display_name, :string, null: false
    add_column :users, :name_by_print_on_checks, :string
    add_column :users, :note, :text
    add_column :users, :role, :integer, null: false, comment: '[0: supper_admin, 1:admin, 2: manager, 3: employee]'
    add_column :users, :address1, :string
    add_column :users, :address2, :string
    add_column :users, :allow_login, :boolean, default: false

    add_index :users, %i[id display_name email phone_number]
  end
end
