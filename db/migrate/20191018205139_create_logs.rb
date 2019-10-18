class CreateLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logs do |t|
      t.string :title
      t.string :date
      t.string :content

      t.timestamps
    end
  end
end
