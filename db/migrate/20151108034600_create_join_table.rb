class CreateJoinTable < ActiveRecord::Migration
  def change
    create_join_table :users, :game_histories do |t|
      # t.index [:user_id, :game_history_id]
      # t.index [:game_history_id, :user_id]
    end
  end
end
