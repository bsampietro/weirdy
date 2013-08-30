# This migration comes from weirdy (originally 20130521202306)
class CreateWeirdyWexceptions < ActiveRecord::Migration
  def change
    create_table :weirdy_wexceptions do |t|
      t.string :kind
      t.string :last_message
      t.integer :occurrences_count
      t.integer :state
      t.timestamp :first_happened_at
      t.timestamp :last_happened_at
      t.text :backtrace
      t.string :backtrace_hash
    end
    
    add_index :weirdy_wexceptions, :last_happened_at
    add_index :weirdy_wexceptions, :occurrences_count
    add_index :weirdy_wexceptions, :state
    add_index :weirdy_wexceptions, [:kind, :backtrace_hash]
  end
end
