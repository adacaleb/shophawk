module Caleb

   def sortDate(date1) #input a date from the SQL export, reorganizes to MM-DD-YYYY format for easy viewing
    year = date1[0..3]
    day = date1[8..9]
    month = date1[5..7]
    date = "#{month}#{day}-#{year}"
    return date
  end

end