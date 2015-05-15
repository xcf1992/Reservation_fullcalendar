class AddCtToTests < ActiveRecord::Migration
  def change
    add_column :tests, :CT, :string
  end
end
