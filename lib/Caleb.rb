module Caleb
  # put "include Caleb" at top of file wanted to use in. #file located in ~/lib/reusable.rb for methods to work accross any controller/model that includes the Reuasable module

  def sortDate(date1) #input a date from the SQL export, reorganizes to MM-DD-YYYY format for easy viewing
    year = date1[0..3]
    day = date1[8..9]
    month = date1[5..7]
    date = "#{month}#{day}-#{year}"
    return date
  end

  def sortDateTime(date1) #input a date from the SQL export, reorganizes to MM-DD-YYYY at TIME format for easy viewing (input format: 2023-07-06T07:00)
    puts date1
    year = date1[0..3]
    day = date1[8..9]
    month = date1[5..7]
    time = date1[11..15]
    date = "#{month}#{day}-#{year} at #{time}"
    return date
  end


end