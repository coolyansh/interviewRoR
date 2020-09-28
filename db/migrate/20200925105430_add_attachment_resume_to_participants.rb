class AddAttachmentResumeToParticipants < ActiveRecord::Migration[5.1]
  def self.up
    change_table :participants do |t|
      t.attachment :resume
    end
  end

  def self.down
    remove_attachment :participants, :resume
  end
end
