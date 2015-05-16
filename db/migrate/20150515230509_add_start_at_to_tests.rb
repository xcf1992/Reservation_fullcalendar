class AddStartAtToTests < ActiveRecord::Migration
  def change
    add_column :tests, :start_at, :datetime
  end
end
