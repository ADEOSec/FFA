class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :activity
      t.references :user, index: true, foreign_key: true
      t.string :user_agent
      t.string :ip

      t.timestamps null: false
    end
  end
end
