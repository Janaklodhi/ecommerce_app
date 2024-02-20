class CreateJoinTableStudentsCourses < ActiveRecord::Migration[7.1]
  def change
    create_join_table :students, :courses do |t|
      t.references :students
      t.references :courses
    end
  end
end
