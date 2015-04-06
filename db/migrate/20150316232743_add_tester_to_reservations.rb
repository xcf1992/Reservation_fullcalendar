class AddTesterToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :tester, :string
  end
end
