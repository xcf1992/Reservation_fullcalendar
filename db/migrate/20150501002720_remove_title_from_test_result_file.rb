class RemoveTitleFromTestResultFile < ActiveRecord::Migration
  def change
    remove_column :test_result_files, :title, :string
  end
end
