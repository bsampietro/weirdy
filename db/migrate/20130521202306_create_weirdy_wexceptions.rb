class CreateWeirdyWexceptions < ActiveRecord::Migration
  def change
    create_table :weirdy_wexceptions do |t|
      t.string :kind
      t.string :last_message
      t.integer :occurrences_count
      t.integer :state
      t.string :raised_in
      t.timestamp :first_happened_at
      t.timestamp :last_happened_at
    end
    
    add_index :weirdy_wexceptions, :last_happened_at
    add_index :weirdy_wexceptions, :occurrences_count
    add_index :weirdy_wexceptions, :state
    add_index :weirdy_wexceptions, [:kind, :raised_in]
  end
end
