class CreateEnrollments < ActiveRecord::Migration[7.0]
  def change
    create_table :enrollments do |t|
      t.string :username, null: false
      t.integer :year, null: false
      t.string :semester, null: false
      t.string :course, null: false
      t.string :status, null: false

      t.timestamps
    end

    add_index :enrollments, :username
    add_index :enrollments, [:year, :semester]
  end
end
