# This migration comes from weirdy (originally 20130521202325)
class CreateWeirdyWexceptionOccurrences < ActiveRecord::Migration
  def change
    create_table :weirdy_wexception_occurrences do |t|
      t.references :wexception
      t.text :message
      t.text :backtrace
      t.timestamp :happened_at
      t.text :data
    end
    
    add_index :weirdy_wexception_occurrences, :wexception_id
  end
end
