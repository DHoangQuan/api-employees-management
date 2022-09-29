class CreateCompany < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :display_name, null: false
      t.string :email
      t.string :phone_number
      t.string :address1
      t.string :address2
      t.string :tax
      t.string :website
      t.string :name_by_print_on_checks
      t.text :note

      t.timestamps
    end

    add_index :companies, %i[id name]
  end
end
