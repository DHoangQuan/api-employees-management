class CreateRate < ActiveRecord::Migration[6.1]
  def change
    create_table :rates do |t|
      t.float :internal_regular
      t.float :internal_ot
      t.float :external_regular
      t.float :external_ot
      t.float :holiday_rate
      t.integer :status, null: false, default: 0, comment: '[0: current, 1:past]'
      t.string :type, null: false
      t.bigint :resource_id, null: false
      t.bigint :company_id, comment: 'Check if user rates of which company'

      t.timestamps
    end

    add_index :rates, %i[type resource_id]
  end
end
