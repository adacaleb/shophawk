class SlideshowsController < ApplicationController
  require 'date'
  require 'CSV'
  before_action :set_slideshow, only: %i[ show update destroy ]

  # GET /slideshows or /slideshows.json
  def index
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
  



  def slides
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
    #puts @operations

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
    CSV.foreach("app/assets/csv/test.csv") do |row|
      start = row[1][0..9]
      start = start.to_date
      ending = row[2][0..9]
      ending = ending.to_date
      #Calculate days between start and end
      #create loop that moves day forward 1 for each day between
      #check when day of week each day is on
      #case function too add name and time to corresponding day of week array
      #in view, do .each on daily arrays to populate who's off what day
      
      #WIP if start.between?(@WeekStarte, )
    end

  end

  # GET /slideshows/1 or /slideshows/1.json
  def show
  end

  # GET /slideshows/new
  def new
    @slideshow = Slideshow.new
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
    #@slideshow = Slideshow.all
    @today = Date.today.to_s + "T07:00"
    @todayEnd = Date.today.to_s + "T04:00"
  end

  def saveTimeOff
    @emp = []

    file = "app/assets/csv/test.csv"
    if CSV.table(file).count >= 0
      CSV.foreach(file) do |row| #imports initial csv and creates all arrays needed
        ending = row[2][0..9]
        ending = ending.to_date
        deleteDate = Date.today - 6 #sets up to delete any entry older than 6 days ago
        if ending > deleteDate && row[0] != "" #if the end date is older than today, don't resave it to the csv
          @emp << { name: row[0], startDate: row[1], endDate: row[2] }
        end
      end
    end
    if params[:name] != "" #for each entry, if the name isn't empty, save it
      @emp << { name: params[:name], startDate: params[:startDate], endDate: params[:endDate] }
    end
    if params[:name2] != ""
      @emp << { name: params[:name2], startDate: params[:startDate2], endDate: params[:endDate2] }
    end
    if params[:name3] != ""
      @emp << { name: params[:name3], startDate: params[:startDate3], endDate: params[:endDate3] }
    end
    if params[:name4] != ""
      @emp << { name: params[:name4], startDate: params[:startDate4], endDate: params[:endDate4] }
    end
    #puts @emp

    
    CSV.open( file, 'w' ) do |writer|
      @emp.each do |emp|
        writer << [ emp[:name], emp[:startDate], emp[:endDate] ]
      end
    end

    #redirect_to slideshows_path
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
