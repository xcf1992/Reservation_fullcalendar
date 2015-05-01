class TestResultFile < ActiveRecord::Base
	has_attached_file :result,
	                  :path => ":rails_root/storage/:basename.:extension"

	do_not_validate_attachment_file_type :result

	validates :result_file_name, uniqueness: true
end