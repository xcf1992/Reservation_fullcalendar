class CreateTestResultFiles < ActiveRecord::Migration
  def change
    create_table :test_result_files do |t|
      t.string :title
      t.attachment :result

      t.timestamps null: false
    end
  end
end
