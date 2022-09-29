class CreateRateSetting < ActiveRecord::Migration[6.1]
  def change
    create_table :rate_settings do |t|
      t.string :wkt_uuid, null: false
      t.bigint :rate_id

      t.timestamps
    end

    add_index :rate_settings, %i[wkt_uuid]
  end
end
