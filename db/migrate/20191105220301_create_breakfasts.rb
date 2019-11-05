class CreateBreakfasts < ActiveRecord::Migration[5.2]
  def change
    create_table :breakfasts do |t|
      t.string :day
      t.string :name
      t.string :string
      t.string :content
      t.string :string

      t.timestamps
    end
  end
end
