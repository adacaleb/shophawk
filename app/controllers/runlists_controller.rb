class RunlistsController < ApplicationController
   before_action :set_tempdata

   def runlist

      @runlist.importjobops
      @tempjob.importjobs
      @tempmat.importmat
      @runlist = Runlist.all
      @tempjobs = Tempjob.all
      @tempmat = Tempmat.all

   end



   def set_tempdata
      @runlist = Runlist.all
      @tempjob = Tempjob.all
      @tempmat = Tempmat.all
   end

end