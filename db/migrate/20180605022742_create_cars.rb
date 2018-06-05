class CreateCars < ActiveRecord::Migration[5.1]
  def change
    create_table :cars do |t|
      t.string :model
      t.string :starting_price
      t.string :brand
      t.string :miles_gallon
      t.integer :km_liter
      t.string :year

      t.timestamps
    end
  end
end
