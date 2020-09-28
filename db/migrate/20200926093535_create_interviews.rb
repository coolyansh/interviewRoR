class CreateInterviews < ActiveRecord::Migration[5.1]
  def change
    create_table :interviews do |t|
      t.references :interviewer
      t.references :interviewee
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
