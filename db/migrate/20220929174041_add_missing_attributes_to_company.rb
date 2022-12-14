class AddMissingAttributesToCompany < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :city, :string
    add_column :companies, :state, :string
    add_column :companies, :zipcode, :string
    add_column :companies, :country, :string

    rename_column :companies, :tax, :tax_id
  end
end
