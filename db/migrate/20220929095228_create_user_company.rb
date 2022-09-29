class CreateUserCompany < ActiveRecord::Migration[6.1]
  def change
    create_table :user_companies do |t|
      t.bigint :user_id
      t.bigint :company_id

      t.timestamps
    end

    add_index :user_companies, %i[user_id company_id]
  end
end
