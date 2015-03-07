class AddEventSeriesIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :event_series_id, :integer
  end
end
