class CreateWeek < ActiveRecord::Migration[6.1]
  def change
    create_table :weeks do |t|
      t.date :from_date
      t.date :to_date

      t.timestamps
    end

    add_index :weeks, %i[from_date]
  end
end
