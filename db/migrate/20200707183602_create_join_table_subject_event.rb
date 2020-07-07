class CreateJoinTableSubjectEvent < ActiveRecord::Migration[5.2]
  def change
    create_join_table :subjects, :events do |t|
      t.index [:event_id, :subject_id]
      t.index [:subject_id, :event_id]
    end
  end
end
