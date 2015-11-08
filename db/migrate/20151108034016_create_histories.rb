class CreateHistories < ActiveRecord::Migration
  def change
    create_table :game_histories do |t|
      t.integer :summoner_id
      t.float :ward_avg
      t.float :gpm_avg
      t.float :cpm_avg
      t.float :kda_avg
      t.float :kill_participation

      t.timestamps null: false
    end
  end
end
