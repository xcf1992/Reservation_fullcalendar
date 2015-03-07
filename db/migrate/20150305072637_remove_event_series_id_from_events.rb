class RemoveEventSeriesIdFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :event_series_id, :integer
  end
end
