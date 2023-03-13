class SlideshowsController < ApplicationController
  require 'date'
  before_action :set_slideshow, only: %i[ show edit update destroy ]

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
        format.html { redirect_to slideshow_url(@slideshow), notice: "Slideshow was successfully updated." }
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
      params.require(:slideshow).permit(:announcements, :quote, :mondayO, :mondayC, :tuesdayO, :tuesdayC, :wednesdayO, :wednesdayC, :thursdayO, :thursdayC, :fridayO, :fridayC, :nextMondayO, :nextMondayC, :nextTuesdayO, :nextTuesdayC, :nextWednesdayO, :nextWednesdayC, :nextThursdayO, :nextThursdayC, :nextFridayO, :nextFridayC)
    end
end
