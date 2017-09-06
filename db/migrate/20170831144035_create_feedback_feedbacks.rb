class CreateFeedbackFeedbacks < ActiveRecord::Migration[5.1]
  def change
    create_table :feedback_feedbacks, id: :uuid do |t|
      t.string :sentiment, null: false
      t.uuid :resource_id, null: false
      t.uuid :user_id, null: false
      t.string :ip, null: false
      t.text :comment

      t.timestamps
    end
    add_index :feedback_feedbacks, :sentiment
    add_index :feedback_feedbacks, :resource_id
    add_index :feedback_feedbacks, :user_id
    add_index :feedback_feedbacks, :ip
  end
end
