class TestResultFile < ActiveRecord::Base
	has_attached_file :result,
	                  :path => ":rails_root/storage/#{Rails.env}#{ENV['RAILS_TEST_NUMBER']}/attachments/:id/:style/:basename.:extension"
	do_not_validate_attachment_file_type :result
end