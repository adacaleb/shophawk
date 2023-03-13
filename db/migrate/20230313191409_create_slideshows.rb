class CreateSlideshows < ActiveRecord::Migration[7.0]
  def change
    create_table :slideshows do |t|
      t.string :announcements
      t.string :quote
      t.string :mondayO
      t.string :mondayC
      t.string :tuesdayO
      t.string :tuesdayC
      t.string :wednesdayO
      t.string :wednesdayC
      t.string :thursdayO
      t.string :thursdayC
      t.string :fridayO
      t.string :fridayC
      t.string :nextMondayO
      t.string :nextMondayC
      t.string :nextTuesdayO
      t.string :nextTuesdayC
      t.string :nextWednesdayO
      t.string :nextWednesdayC
      t.string :nextThursdayO
      t.string :nextThursdayC
      t.string :nextFridayO
      t.string :nextFridayC

      t.timestamps
    end
  end
end
