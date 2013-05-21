# This migration comes from weirdy (originally 20130521202325)
class CreateWeirdyWexceptionOccurrences < ActiveRecord::Migration
  def change
    create_table :weirdy_wexception_occurrences do |t|
      t.references :wexception
      t.text :backtrace
      t.string :backtrace_hash
      t.timestamp :happened_at
      t.text :data
    end
    
    add_index :weirdy_wexception_occurrences, :wexception_id
    add_index :weirdy_wexception_occurrences, :happened_at
  end
end
