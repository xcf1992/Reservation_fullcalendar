class TestResultFilesController < ApplicationController
	def create
		@file = TestResultFile.new(file_params)

		if @file.save
			text = File.open(@file.result.path, "rb:UTF-16LE").read.encode("utf-8")
			results = CSV.parse(text)

			id = nil
			startTime = nil
			endTime = nil
			results.each do |row| 
			  if row[0] == "Sample ID"
			  	id = row[1]
			  end

			  if row[0] == "Start Time"
			  	startTime = DateTime.strptime(row[1], "%m/%d/%y %H:%M:%S")
			  end

			  if row[0] == "End Time"
			  	endTime = DateTime.strptime(row[1], "%m/%d/%y %H:%M:%S")
			  end

		  	  if row[0] == "Test Result"
		  	  	ct = nil
			  	ng = nil
			  	final = nil
		  	  	
		  	  	if row[1] == "INVALID"
		  	  		ct = "INVALID"
		  	  		ng = "INVALID"
		  	  		final = "INVALID"
		  	  	else
			  	  testResult = row[1].split(";")
			  	  ctResult = testResult[0]
			  	  ngResult = testResult[1]

			  	  if ctResult == "CT NOT DETECTED"
			  	  	ct = "Negative"
			  	  else
			  	  	ct = "Positive"
			  	  end

			  	  if ngResult == " NG NOT DETECTED"
			  	  	ng = "Negative"
			  	  else
			  	  	ng = "Positive"
			  	  end
			  	  
			  	  if ct == "Negative" && ng == "Negative"
			  	  	final = "Negative"
			  	  else
			  	  	final = "Positive"
			  	  end
			  	end
			  	newTest = Test.new(:result => final, :testId => id, :CT => ct, :NG => ng, :start_at => startTime, :end_at => endTime)
			  	newTest.save
		  	  end
			end			
			redirect_to tests_path, notice: 'File has been uploaded successfully.'
		else
			redirect_to tests_path, notice: 'File Upload failed, maybe you are trying to upload the same file.'
		end
	end

	def new
		@file = TestResultFile.new
	end

	def index
		@files = TestResultFile.all
		@newFile = TestResultFile.new
	end

	def show
		@file = TestResultFile.find_by_id(params[:id])
		text = File.open(@file.result.path, "rb:UTF-16LE").read.encode("utf-8")
		@results = CSV.parse(text)
	end

	def destroy
		@file = TestResultFile.find_by_id(params[:id])
		@file.destroy
	    respond_to do |format|
	      format.html { redirect_to test_result_files_path, notice: 'File has been successfully deleted.' }
	      format.json { head :no_content }
	    end
	end

	def download
		file = TestResultFile.find_by_id(params[:id])
  		send_file file.result.path, :type => file.result_content_type
	end

	private
	    def file_params
	      params.require(:test_result_file).permit(:title, :result)
	    end
end