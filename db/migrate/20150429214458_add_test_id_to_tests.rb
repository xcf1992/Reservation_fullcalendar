class AddTestIdToTests < ActiveRecord::Migration
  def change
    add_column :tests, :testId, :string
  end
end
