class AddShowupToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :showup, :boolean
  end
end
