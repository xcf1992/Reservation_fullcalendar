class AddConfirmationToClients < ActiveRecord::Migration
  def change
    add_column :clients, :confirmation, :string
  end
end
