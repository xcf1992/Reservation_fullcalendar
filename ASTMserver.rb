require 'thread'
require 'socket'
require 'time'
require 'active_record'
require 'sqlite3'

ACK = "\006"
ENQ = "\005"
EOT = "\004"
STX = "\002"
ETX = "\003"
ETB = "\x17"

# Change the following to reflect your database settings
ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3', # or 'postgresql' or 'sqlite3'
  pool: '5',
  timeout: '5000',
  database: '/home/avrccalendar/www/db/development.sqlite3'
)

class Test < ActiveRecord::Base
  validates :testId, uniqueness: true
end

Socket.tcp_server_loop(9999) do |connection|
  begin
    puts connection.remote_address.to_s + "Connected"
    fNum = 1
    filename = ""

    while data = connection.readpartial(1024 * 100) do
      first = data[0]
      last = data[-5]
      path = "/home/avrccalendar/www/ASTM_Log/" + Time.now.strftime("%Y-%m-%d")
      Dir.mkdir(path) unless File.exists?(path)

      if first == ENQ
        puts "receive ENQ"
        fNum = 1

        if filename == ""
          puts "filename is empty"
          filename = Time.now.strftime("%Y-%m-%d_%H:%M:%S")
        else
          puts "old file name is " + filename
          puts "right now is " + Time.now.strftime("%Y-%m-%d_%H:%M:%S")
          if Time.strptime(filename, "%Y-%m-%d_%H:%M:%S") >= Time.strptime(Time.now.strftime("%Y-%m-%d_%H:%M:%S"), "%Y-%m-%d_%H:%M:%S")
            puts "Time is fall behind"
            filename = (Time.strptime(filename, "%Y-%m-%d_%H:%M:%S") + 1).strftime("%Y-%m-%d_%H:%M:%S")
          else
            puts "Time goes fast"
            filename = Time.now.strftime("%Y-%m-%d_%H:%M:%S")
          end
        end
        puts filename

        connection.write(ACK)

      elsif first == STX
        frame = data[1]
        puts "receive STX " + frame
        file = File.open(path + "/" + filename, "a")
        puts "fNum" + " = " + fNum.to_s

        if frame.to_i == fNum
          puts "frame number as expected"
          puts last.to_s
          if last == ETB
            puts "receive ETB"

            allData = File.open(path + "/" + Time.now.strftime("%Y-%m-%d"), "a")
            allData.write(data[2...-5])
            allData.close

            file.write(data[2...-5])
            file.flush
            fNum = (fNum + 1) % 8
          
          elsif last == ETX
            puts "receive ETX"

            allData = File.open(path + "/" + Time.now.strftime("%Y-%m-%d"), "a")
            allData.write(data[2...-5])
            allData.close

            file.write(data[2...-5])
            file.close
            fNum = 1
            
            data = File.read(path + "/" + filename)
            content = data.split('|').reject{|item| item == ""}
            start_at = Time.now
            end_at = Time.now
            id = ""
            result = ""
            ctResult = ""
            ngResult = ""
            i = 0

            while i < content.size
              if content[i] == "Lead The Way Clinic"
                puts content[i]
                puts content[i + 1]
                puts content[i + 2]

                start_at = Time.strptime(content[i + 1], "%Y%m%d%H%M%S")
                end_at = Time.strptime(content[i + 2], "%Y%m%d%H%M%S")
              elsif content[i] == "^^^CPHD_CT_NG"
                puts content[i]
                puts content[i - 1]

                id = content[i - 1]
              elsif content[i] == "^CPHD_CT_NG^^1^Xpert CT_NG^3^CT^"
                puts content[i]
                puts content[i + 1][0..-2]

                ctString = content[i + 1][0..-2]
                if ctString == "CT NOT DETECTED"
                  ctResult = "Negative"
                elsif ctString == "CT DETECTED"
                  ctResult = "Positive"
                elsif ctString == "ERROR"
                  ctResult = "Error"
                elsif ctString == "INVALID"
                  ctResult = "Invalid"
                end
              elsif content[i] == "^CPHD_CT_NG^^2^Xpert CT_NG^3^NG^"
                puts content[i]
                puts content[i + 1][0..-2]
                
                ngString = content[i + 1][0..-2]
                if ngString == "NG NOT DETECTED"
                  ngResult = "Negative"
                elsif ngString == "NG DETECTED"
                  ngResult = "Positive"
                elsif ngString == "ERROR"
                  ngResult = "Error"
                elsif ngString == "INVALID"
                  ngResult = "Invalid"
                end

                result = "Negative"
                if ngResult == "Positive" || ctResult == "Positive"
                  result = "Positive"
                end
                if ngResult == "Error" || ctResult == "Error"
                  result = "Error"
                end
                if ngResult == "INVALID" || ctResult == "INVALID"
                  result = "INVALID"
                end
                newTest = Test.new(:result => result, :testId => id, :CT => ctResult, :NG => ngResult, :start_at => start_at, :end_at => end_at)
                newTest.save
              end

              i = i + 1
            end

          end
        end
        connection.write(ACK)

      elsif first == EOT
        puts "Receive EOT"
        allData = File.open(path + "/" + Time.now.strftime("%Y-%m-%d"), "a")
        allData.write("\n\n")
        allData.close

        connection.write(ACK)
      else
        connection.write(ACK)
      end
    end
  rescue EOFError
  end

  allData.close
  puts "Disconnected"
  conneciton.close
end
