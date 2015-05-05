class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :identification
      t.string :email
      t.string :phone

      t.timestamps null: false
    end
  end
end
