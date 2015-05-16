class AddEndAtToTests < ActiveRecord::Migration
  def change
    add_column :tests, :end_at, :datetime
  end
end
