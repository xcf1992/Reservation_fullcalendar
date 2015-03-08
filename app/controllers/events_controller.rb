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
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  def clients
    @events = Event.where(:occupied => true).where('events.start_time > ?', DateTime.now.beginning_of_day)
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
    if params[:event][:repeat] == "Does not repeat"
      @event = Event.new(event_params)
      if @event.save
          redirect_to '/events'
          #format.html { redirect_to @event, notice: 'Event was successfully created.' }
          #format.json { render :show, status: :created, location: @event }
      else
          render 'new'
      end

    else
      title = params[:event][:title]
      desc = params[:event][:description]
      
      st_year = params[:event]["start_time(1i)".to_sym]
      st_month = params[:event]["start_time(2i)".to_sym]
      st_day = params[:event]["start_time(3i)".to_sym]
      st_hour = params[:event]["start_time(4i)".to_sym]
      st_minute = params[:event]["start_time(5i)".to_sym]
      
      et_year = params[:event]["end_time(1i)".to_sym]
      et_month = params[:event]["end_time(2i)".to_sym]
      et_day = params[:event]["end_time(3i)".to_sym]
      et_hour = params[:event]["end_time(4i)".to_sym]
      et_minute = params[:event]["end_time(5i)".to_sym]

      st = st_day+"/"+st_month+"/"+st_year+" "+st_hour+":"+st_minute
      et = et_day+"/"+et_month+"/"+et_year+" "+et_hour+":"+et_minute
      start_hour = DateTime.strptime(st, "%d/%m/%Y %H:%M").strftime("%k").to_i
      end_hour = DateTime.strptime(et, "%d/%m/%Y %H:%M").strftime("%k").to_i

      nst = DateTime.strptime(st, "%d/%m/%Y %H:%M")
      net = nst + 30.minutes

      while net <= DateTime.strptime(et, "%d/%m/%Y %H:%M")
        current_hour = nst.strftime("%k").to_i
        if current_hour >= start_hour && current_hour <= end_hour
          @newEvent = Event.new(:title => title, :description => desc, :start_time => nst, :end_time => net, :occupied => false)
          @newEvent.save
        end
        nst = net
        net = nst + 30.minutes
      end
      redirect_to '/events'
    end

  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    @event = Event.find_by_id(params[:event][:id])
    if params[:event][:commit_button] == "Update All Occurrence"
      @events = @event.event_series.events
      @event.update_events(@events, event_params)
    
    elsif params[:event][:commit_button] == "Update All Following Occurrence"
      @events = @event.event_series.events.find(:all, :conditions => ["start_time > '#{@event.start_time.to_formatted_s(:db)}' "])
      @event.update_events(@events, event_params)
    
    else
      @event.attributes = event_params
      @event.save
    end
    
    render :nothing => true

    #respond_to do |format|
      #if @event.update(event_params)
       # format.html { redirect_to @event }
      #  format.json { render :show, status: :ok, location: @event }
      #else
       # format.html { render :edit }
      #  format.json { render json: @event.errors, status: :unprocessable_entity }
     # end
    #end
  end

  def delete_all
    dl_year = params["delete_time(1i)".to_sym]
    dl_month = params["delete_time(2i)".to_sym]
    dl_day = params["delete_time(3i)".to_sym]
    dl_hour = params["delete_time(4i)".to_sym]
    dl_minute = params["delete_time(5i)".to_sym]

    dlt = dl_day+"/"+dl_month+"/"+dl_year+" "+dl_hour+":"+dl_minute
    delete_time = DateTime.strptime(dlt, "%d/%m/%Y %H:%M")

    Event.where('events.start_time < ?', delete_time).destroy_all
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
    @event = Event.find params[:id]
    @reservation = @event.reservation

    respond_to do |format|
      format.html { render :layout => false}
    end
  end

  def reservation_without_info
    @event = Event.find params[:id]

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
      params.require(:event).permit('title', 'description', 'start_time', 'end_time', 'occupied', 'period', 'frequency', 'commit_button')
    end
end
