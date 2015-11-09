class CreateDivStats < ActiveRecord::Migration
  def change
    create_table :div_stats do |t|
      t.string :division_name
      t.float :ward_avg
      t.float :gpm_avg
      t.float :cpm_avg
      t.float :kda_avg
      t.float :kp_avg

      t.timestamps null: false
    end
  end
end
