class RunlistsController < ApplicationController
   before_action :set_tempdata #sets up variables

   def runlist #imports csv fiiles and loads objects

      @tempop.importjobops
      @tempjob.importjobs
      @tempmat.importmat
      @tempop = Tempop.all
      @tempjobs = Tempjob.all
      @tempmat = Tempmat.all

   end



   def set_tempdata
      @tempop = Tempop.all
      @tempjob = Tempjob.all
      @tempmat = Tempmat.all
   end

end