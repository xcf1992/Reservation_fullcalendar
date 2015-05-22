require 'thread'
require 'socket'
require 'time'

ACK = "\006"
ENQ = "\005"
EOT = "\004"
STX = "\002"
ETX = "\003"
ETB = "\x17"

Socket.tcp_server_loop(4481) do |connection|
  begin
    puts connection.remote_address.to_s + "Connected"
    fNum = 1
    endF1 = File.open("endC1", "a")
    endF2 = File.open("endC2", "a")
    endF3 = File.open("endC3", "a")
    endF4 = File.open("endC4", "a")
    endF5 = File.open("endC5", "a")
    firstF = File.open("firstC", "a")
    filename = ""
    enqN = 0

    while data = connection.readpartial(1024 * 100) do
      first = data[0]
      last = data[-5]
      firstF.write(first)
      endF1.write(data[-1])
      endF2.write(data[-2])
      endF3.write(data[-3])
      endF4.write(data[-4])
      endF5.write(last)

      if first == ENQ
        puts "receive ENQ"
        enqN = enqN + 1
        puts enqN
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
        file = File.open(filename, "a")
        puts "fNum" + " = " + fNum.to_s

        if frame.to_i == fNum
          puts "frame number as expected"
          puts last.to_s
          if last == ETB
            puts "receive ETB"

            allData = File.open(Time.now.strftime("%Y-%m-%d"), "a")
            allData.write(data[2...-5])
            allData.close

            file.write(data[2...-5])
            file.flush
            fNum = (fNum + 1) % 8
          
          elsif last == ETX
            puts "receive ETX"

            allData = File.open(Time.now.strftime("%Y-%m-%d"), "a")
            allData.write(data[2...-5])
            allData.close

            file.write(data[2...-5])
            file.close
            fNum = 1
          end
        end
        connection.write(ACK)

      elsif first == EOT
        puts "Receive EOT"
        allData = File.open(Time.now.strftime("%Y-%m-%d"), "a")
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
  endF1.close
  endF2.close
  endF3.close
  endF4.close
  endF5.close
  firstF.close
  puts "Disconnected"
  conneciton.close
end