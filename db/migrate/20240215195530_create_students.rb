class CreateStudents < ActiveRecord::Migration[7.1]
  def change
    create_table :students do |t|
      t.string :name
      t.string :college
      t.integer :roll_number
      t.timestamps
    end
  end
end
