class RunlistsController < ApplicationController
   

 def runlist
   @runlist = Runlist.all
   @runlist.importjobops
   @runlist = Runlist.all

   @runlist.each do |run| 
      @job = run.Job 
   end 
 end

end