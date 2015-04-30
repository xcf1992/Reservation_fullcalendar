class TestResultFilesController < ApplicationController
	def create
		@file = TestResultFile.new(file_params)

		if @file.save
			text = File.open(@file.result.path, "rb:UTF-16LE").read.encode("utf-8")
			results = CSV.parse(text)

			id = nil
			results.each do |row| 
			  if row[0] === "Sample ID"
			  	id = row[1]
			  end
		  	  if row[0] === "Test Result"
		  	  	testResult = row[1]
		  	  	newTest = Test.new(:result => testResult, :testId => id)
		  	  	newTest.save
		  	  end
			end
			
			redirect_to tests_path, notice: 'File has been uploaded successfully.'
		else
			redirect_to tests_path, notice: 'File Upload failed.'
		end
	end

	def new
		@file = TestResultFile.new
	end

	private
	    def file_params
	      params.require(:test_result_file).permit(:title, :result)
	    end
end