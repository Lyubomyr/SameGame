class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :user
      t.integer :width
      t.integer :height
      t.integer :colors
      t.integer :score
      t.text :matrix

      t.timestamps
    end
  end
end
