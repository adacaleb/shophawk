class SlideshowsController < ApplicationController
  require 'date'
  require 'CSV'
  include Caleb
  before_action :set_slideshow, only: %i[ show update destroy ]

  # GET /slideshows or /slideshows.json
  def index
    if Slideshow.where(:id => 1).exists? #creates a record if none exists, prevents errors
    else
      @slideshow = Slideshow.new(id: 1)
      @slideshow.save
    end
    @slideshow = Slideshow.find(1)
    @weekStart = Date.today.beginning_of_week(:monday)
    @nextWeekStart = @weekStart + 1.week
    @weekEnd = @weekStart + 4.days
    @weekStart = @weekStart.to_s
    @weekEnd = @weekEnd.to_s
    @weekStart = @weekStart[5..9]
    @weekEnd = @weekEnd[5..9]
    @nextWeekEnd = @nextWeekStart + 4.days
    @nextWeekStart = @nextWeekStart.to_s
    @nextWeekEnd = @nextWeekEnd.to_s
    @nextWeekStart = @nextWeekStart[5..9]
    @nextWeekEnd = @nextWeekEnd[5..9]
    @totalSlides = 5
    @nextbtn = 2
    @currentSlide = 1
  end
  
  def slides #run for slides.turbo_stream.erb
    @slideshow = Slideshow.find(1)
    @weekStart = Date.today.beginning_of_week(:monday) #using gem 'working_hours'
    puts @weekStart
    @nextWeekStart = @weekStart + 1.week
    @weekEnd = @weekStart + 4.days
    @weekStart = @weekStart.to_s
    @weekEnd = @weekEnd.to_s
    @weekStart = @weekStart[5..9]
    @weekEnd = @weekEnd[5..9]
    @nextWeekEnd = @nextWeekStart + 4.days
    @nextWeekStart = @nextWeekStart.to_s
    @nextWeekEnd = @nextWeekEnd.to_s
    @nextWeekStart = @nextWeekStart[5..9]
    @nextWeekEnd = @nextWeekEnd[5..9]
    @currentSlide = params[:nextbtn].to_i
    @totalSlides = 5
    @nextbtn = @currentSlide + 1
    if @nextbtn > @totalSlides
      @nextbtn = 1
    end
    @operations = Runlist.where(status: "O").where().not(dots: nil) #select operations with dots and open
    @operations = @operations.uniq  { |op| op.Job }
    @operations = @operations.sort_by { |op| [op.Job_Sched_End, -op.dots] }
    @operations.each do |op| #sorts the date field to look correct for user
      #operation start format
      year = op.Sched_Start[0..3]
      day = op.Sched_Start[8..9]
      month = op.Sched_Start[5..7]
      op.Sched_Start = "#{month}#{day}-#{year}"
      #job ship date format
      year = op.Job_Sched_End[0..3]
      day = op.Job_Sched_End[8..9]
      month = op.Job_Sched_End[5..7]
      op.Job_Sched_End = "#{month}#{day}-#{year}" 
    end
    #arrays for each day of the week for employee time off to populate
    @mondaye = []
    @tuesdaye = []
    @wednesdaye = []
    @thursdaye = []
    @fridaye = []
    @nextMondaye = []
    @nextTuesdaye = []
    @nextWednesdaye = []
    @nextThursdaye = []
    @nextFridaye = []
    @weekStarte = Date.today.beginning_of_week(:monday) #using gem 'working_hours'
    @nextWeekStarte = @weekStarte + 1.week
    @twoWeekStarte = @weekStarte + 2.week

    i = 0
    CSV.foreach("app/assets/csv/timeOff.csv") do |row|
      if i > 0 
        start = row[1][0..9]
        start = start.to_date
        ending = row[2][0..9]
        ending = ending.to_date
        startTime = row[1][11..15]
        endTime = row[2][11..15]
        person = row[0]
        dayBetween = start.working_days_until(ending)
        if dayBetween == 0 #if only 1 day with time off
          week = calcWeek(start) #gets week day is in
          off = person.to_s + " " + startTime.to_s + "-" + endTime.to_s
          saveTimeOffDay(start, week, off) #saves name to whatever day in the next two weeks the date belongs too. 
        end
        if dayBetween > 0 #if multiple days off
          day = start
          week = calcWeek(day)
          off = person.to_s + " " + startTime.to_s + "-" + "03:00"
          saveTimeOffDay(day, week, off)
          i = 1
          while i <= dayBetween do #loop through each day
            day = day + 1.working.days
            if day == ending
              off = person.to_s + " " + "07:00" + "-" + endTime.to_s
            end
            if day < ending 
              off = person.to_s + " " +  "07:00" + "-" + "03:00"
            end
            if startTime.to_s == "07:00" && endTime.to_s == "03:00"
              off = person.to_s + " - All Day"
            end
            week = calcWeek(day)
            saveTimeOffDay(day, week, off)
            i += 1
          end
        end
      end      
      i += 1
    end
  end

  def saveTimeOffDay(day, week, off)
    day = day.strftime("%A") #saves dates of name of the day ex. Monday, Tuesday
        if week == 0 #if during this week
          case day
          when "Monday"
            @mondaye << off
          when "Tuesday"
            @tuesdaye << off
          when "Wednesday"
            @wednesdaye << off
          when "Thursday"
            @thursdaye << off
          when "Friday"
            @fridaye << off
          end
        end
        if week == 1
          case day
          when "Monday"
            @nextMondaye << off
          when "Tuesday"
            @nextTuesdaye << off
          when "Wednesday"
            @nextWednesdaye << off
          when "Thursday"
            @nextThursdaye << off
          when "Friday"
            @nextFridaye << off
          end
        end
  end

  def calcWeek(date) #calculates if the date is this week or next. date format: "yyyy/mm/dd"
    if date >= @weekStarte && date < @nextWeekStarte
      week = 0
    end 
    if date >= @nextWeekStarte && date < @twoWeekStarte #if during next week
      week = 1
    end
    return week
  end

  # GET /slideshows/1/edit
  def edit
    @slideshow = Slideshow.find(1)
    @weekStart = Date.today.beginning_of_week(:monday)
    @nextWeekStart = @weekStart + 1.week
    @weekEnd = @weekStart + 4.days
    @weekStart = @weekStart.to_s
    @weekEnd = @weekEnd.to_s
    @weekStart = @weekStart[5..9]
    @weekEnd = @weekEnd[5..9]
    @nextWeekEnd = @nextWeekStart + 4.days
    @nextWeekStart = @nextWeekStart.to_s
    @nextWeekEnd = @nextWeekEnd.to_s
    @nextWeekStart = @nextWeekStart[5..9]
    @nextWeekEnd = @nextWeekEnd[5..9]
  end

  def editTimeOff
    @today = Date.today.to_s + "T07:00"
    @todayEnd = Date.today.to_s + "T03:00"

    @off = []
    i = 0
    CSV.foreach("app/assets/csv/timeOff.csv") do |row|      
      if i > 0 #prevents header from showing
        start = sortDateTime(row[1])
        ending = sortDateTime(row[2])
        @off << { number: row[3], name: row[0], start: start, end: ending }
      end
      i += 1
    end
    @off = @off.sort_by { |a| a[:name] }
  end

  def saveTimeOff
    @emp = []

    file = "app/assets/csv/timeOff.csv"
    if CSV.table(file).count >= 0
      @idcount = 1
      i = 0
      CSV.foreach(file) do |row| #imports initial csv and creates all arrays needed
        if i > 0
          ending = row[2][0..9]
          ending = ending.to_date
          deleteDate = Date.today - 6 #sets up to delete any entry older than 6 days ago
          if ending > deleteDate && row[0] != "" #if the end date is older than today, don't resave it to the csv
            @emp << { name: row[0], startDate: row[1], endDate: row[2], id: @idcount }
            @idcount += 1
          end
        end 
        i += 1
      end
    end
    if params[:name] != "" #for each entry, if the name isn't empty, save it
      @emp << { name: params[:name], startDate: params[:startDate], endDate: params[:endDate], id: @idcount }
      @idcount+= 1
    end
    if params[:name2] != ""
      @emp << { name: params[:name2], startDate: params[:startDate2], endDate: params[:endDate2], id: @idcount }
      @idcount+= 1
    end
    if params[:name3] != ""
      @emp << { name: params[:name3], startDate: params[:startDate3], endDate: params[:endDate3], id: @idcount }
      @idcount += 1
    end
    if params[:name4] != ""
      @emp << { name: params[:name4], startDate: params[:startDate4], endDate: params[:endDate4], id: @idcount }
    end
    CSV.open( file, 'w', :write_headers=> true,
    :headers => ["name","start","end", "id"] ) do |writer|
      @emp.each do |emp|
        writer << [ emp[:name], emp[:startDate], emp[:endDate], emp[:id] ]
      end
    end
    redirect_to "/slideshows/editTimeOff"
  end

  def delTimeOff
    table = CSV.table("app/assets/csv/timeOff.csv")

    table.delete_if do |row|
      row[3].to_i == params[:id].to_i
    end
    File.open("app/assets/csv/timeOff.csv", 'w') do |f|
      f.write(table.to_csv)
    end
    redirect_to "/slideshows/editTimeOff"
  end

  

  # GET /slideshows/1 or /slideshows/1.json
  def show
  end

  # GET /slideshows/new
  def new
    @slideshow = Slideshow.new
  end

  # POST /slideshows or /slideshows.json
  def create
    @slideshow = Slideshow.new(slideshow_params)

    respond_to do |format|
      if @slideshow.save
        format.html { redirect_to slideshow_url(@slideshow), notice: "Slideshow was successfully created." }
        format.json { render :show, status: :created, location: @slideshow }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @slideshow.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /slideshows/1 or /slideshows/1.json
  def update
    respond_to do |format|
      if @slideshow.update(slideshow_params)
        format.html { redirect_to slideshows_path, notice: "Slideshow was successfully updated." }
        format.json { render :show, status: :ok, location: @slideshow }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @slideshow.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /slideshows/1 or /slideshows/1.json
  def destroy
    @slideshow.destroy

    respond_to do |format|
      format.html { redirect_to slideshows_url, notice: "Slideshow was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_slideshow
      @slideshow = Slideshow.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def slideshow_params
      params.require(:slideshow).permit(:todoList, :announcements, :quote, :saturday, :nextSaturday, :mondayO, :mondayC, :tuesdayO, :tuesdayC, :wednesdayO, :wednesdayC, :thursdayO, :thursdayC, :fridayO, :fridayC, :saturdayO, :saturdayC, :nextMondayO, :nextMondayC, :nextTuesdayO, :nextTuesdayC, :nextWednesdayO, :nextWednesdayC, :nextThursdayO, :nextThursdayC, :nextFridayO, :nextFridayC, :nextSaturdayO, :nextSaturdayC)
    end
end
