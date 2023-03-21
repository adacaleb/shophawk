class ChartsController < ApplicationController

	def total_jobs
		render json: Runlist.group_by_day(:created_at, last: 4).count
	end
end