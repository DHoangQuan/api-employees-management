class CreateWorkingTime < ActiveRecord::Migration[6.1]
  def change
    create_table :working_times, comment: 'this table is used for user working time and default working time' do |t|
      t.string :uuid, null: false
      t.string :display_name
      t.string :monday
      t.string :tuesday
      t.string :wednesday
      t.string :thursday
      t.string :friday
      t.string :saturday
      t.string :sunday
      t.float  :total_hours
      t.float  :i_reg_money
      t.float  :i_ot_money
      t.float  :e_reg_money
      t.float  :e_ot_money
      t.text   :note
      t.bigint :company_id, null: false
      t.bigint :user_id
      t.bigint :rate_id
      t.bigint :week_id, null: false

      t.timestamps
    end

    add_index :working_times, %i[display_name uuid]
  end
end
