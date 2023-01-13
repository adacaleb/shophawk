class RunlistsController < ApplicationController
   

 def runlist
   @runlist = Runlist.all
   @runlist.importjobops
   @runlist = Runlist.all
    puts "hello you sexy beast"
 end

end