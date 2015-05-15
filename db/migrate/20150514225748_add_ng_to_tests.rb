class AddNgToTests < ActiveRecord::Migration
  def change
    add_column :tests, :NG, :string
  end
end
