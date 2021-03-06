class EventsController < ApplicationController
  skip_before_filter :require_login, only: [:occupied, :available]

  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def occupied
    @events = Event.where(:occupied => true).where('events.start_time > ?', DateTime.now.beginning_of_day)
  end

  def available
    @events = Event.where(:occupied => false).where('events.start_time > ?', DateTime.now.beginning_of_day)
  end
  # GET /events
  # GET /events.json
  def index
    @eventN = Event.new(:repeat => "Does not repeat")
    @event = Event.find_by_id(params[:id])
    @user = User.new
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  def clients
    @events = Event.where(:occupied => true).where('events.start_time > ?', DateTime.now.beginning_of_day).where('events.start_time < ?', DateTime.now.end_of_day)
  end

  # GET /events/new
  def new
    @event = Event.new(:repeat => "Does not repeat")
  end

  # GET /events/1/edit
  def edit
    @event = Event.find_by_id(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    title = params[:event][:title]
    desc = params[:event][:description]
    # get the start time of events creation
    start_time_str = params[:start_time]
    start_time = DateTime.strptime(start_time_str, "%Y - %m - %d %I:%M %p")

    # get the end time of events creation
    end_time_str = params[:end_time]
    endT = DateTime.strptime(end_time_str, "%Y - %m - %d %I:%M %p")

    # only create one event in this case
    if params[:event][:repeat] == "Does not repeat"
      @event = Event.new(:title => title, :description => desc, :start_time => start_time, :end_time => endT, :occupied => false)
      if @event.save
          redirect_to events_path
          #format.html { redirect_to @event, notice: 'Event was successfully created.' }
          #format.json { render :show, status: :created, location: @event }
      else
          render 'new'
      end

    # create multiple events in this case from start time to end time, by create each event one by one.
    else
      gap = 30.minutes
      if params[:event][:repeat] == "Reapeat Every Hour"
        gap = 1.hours
      end

      exception = params[:event][:exception]
      replication = params[:event][:replicate]

      # there is gap time for the creation of events in every day
      if exception == "1"
        except_start = params[:event][:except_time_start]
        except_end = params[:event][:except_time_end]

        # get the start and end time of the gap time
        except_from = DateTime.strptime(except_start, "%I:%M %p")
        except_to = DateTime.strptime(except_end, "%I:%M %p")
      end

      # get the start and end time in Time format
      start_hour_minute = start_time.strftime("%H:%M")
      start_date = start_time.strftime("%Y - %m - %d")
      end_hour_minute = DateTime.strptime(params[:end_time], "%Y - %m - %d %I:%M %p").strftime("%H:%M")

      # find out whether the creation is under replicaiton condition
      if (replication == "No Replication")
        stop_time_str = params[:end_time]
        stop_time = DateTime.strptime(stop_time_str, "%Y - %m - %d %I:%M %p")
      else
        # get the stop date of the replication
        stop_time_str = params[:event][:stop_time] + " " + end_hour_minute
        stop_time = DateTime.strptime(stop_time_str, "%Y - %m - %d %H:%M")
      end

      # the default working time is from 9am to 8pm
      from = DateTime.strptime(start_hour_minute, "%H:%M")
      nine_oclock_am = DateTime.strptime("09:00", "%H:%M")
      to = DateTime.strptime(end_hour_minute, "%H:%M")
      eight_oclock_pm = DateTime.strptime("20:00", "%H:%M")

      # if the creation time is set out of the working time range, events will not be created out of the working time range
      if from < nine_oclock_am
        from = nine_oclock_am
      end
      if to > eight_oclock_pm 
        
        to = eight_oclock_pm
      end

      # get the start time and end time of next event needs to be created
      nst = DateTime.strptime(start_time_str, "%Y - %m - %d %I:%M %p")
      net = nst + gap

      caliberate = 0
      
      # keep creating new events until the end time of next created event is out of the creating time range
      while net <= stop_time
        nst_hour_minute = DateTime.strptime(nst.strftime("%H") + nst.strftime("%M"), "%H%M")
        net_hour_minute = DateTime.strptime(net.strftime("%H") + net.strftime("%M"), "%H%M")
        nst_day = nst.strftime("%u").to_i

        # make sure the the end time creating events is not out of working time range, nor in the gap time 
        if (nst_hour_minute >= from && ((replication == "No Replication" && net_hour_minute <= eight_oclock_pm) || (replication != "No Replication" && net_hour_minute <= to))) && 
           (replication == "No Replication" || (replication == "Replicate On Weekdays" && nst_day >= 1 && nst_day <= 5) || (replication == "Replicate On Weekends" && nst_day == 6)) 
          if exception == "1"
            if net_hour_minute <= except_from
              @newEvent1 = Event.new(:title => title, :description => desc, :start_time => nst, :end_time => net, :occupied => false)
              @newEvent1.save
            elsif nst_hour_minute >= except_to
              @newEvent2 = Event.new(:title => title, :description => desc, :start_time => nst, :end_time => net, :occupied => false)
              @newEvent2.save
            end

            if nst_hour_minute >= except_from && nst_hour_minute < except_to && (nst_hour_minute + gap) > except_to
              caliberate = 1
            end
          else
            @newEvent = Event.new(:title => title, :description => desc, :start_time => nst, :end_time => net, :occupied => false)
            @newEvent.save
          end
        end

        # if the start time of a new created event of each new day is not start from 9am or the start time set by the tester, caliberate it to be the start time 
        if caliberate == 0
          nst = net
        else
          nst = DateTime.strptime(nst.strftime("%Y") + nst.strftime("%m") + nst.strftime("%d") + except_to.strftime("%H") + except_to.strftime("%M"), "%Y%m%d%H%M")
          caliberate = 0
        end

        if nst.strftime("%k").to_i == 23 && (nst + gap).strftime("%k").to_i == 0
          nst = (nst + gap).beginning_of_day
        end
        net = nst + gap
      end

      redirect_to events_path, notice: 'Events have been created successfully.'
    end

  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
  end

  def delete_all
    # delete all the events in the time range selected by the tester
    dl_time_start = params[:delete_time_start]
    dl_time_end = params[:delete_time_end]

    delete_time_start = DateTime.strptime(dl_time_start, "%Y - %m - %d")
    delete_time_end = DateTime.strptime(dl_time_end, "%Y - %m - %d")

    @events = Event.where('events.start_time < ?', delete_time_end.end_of_day).where('events.start_time > ?', delete_time_start.beginning_of_day).destroy_all
    redirect_to events_path, notice: 'Events have been deleted successfully.'
  end
  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find_by_id(params[:id])
    #if params[:delete_all] == 'true'
    #  @event.event_series.destroy
    
    #elsif params[:delete_all] == 'future'
    #  @events = @event.event_series.events.find(:all, :conditions => ["start_time > '#{@event.start_time.to_formatted_s(:db)}' "])
    #  @event.event_series.events.delete(@events)
    
    #else
    #  @event.destroy
    #   redirect_to '/events'
    #end

    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  def reservation_info
    @event = Event.find(params[:id])
    @reservation = @event.reservation

    respond_to do |format|
      format.html { render :layout => false}
    end
  end

  def reservation_without_info
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit('title', 'description', 'start_time', 'end_time', 'occupied')
    end
end
