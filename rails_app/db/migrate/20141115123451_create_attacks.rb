class CreateAttacks < ActiveRecord::Migration
  def change
    create_table :attacks do |t|
      t.string  :status, :null => false, :default => :still_not
      t.boolean :kill,   :null => false, :default => false
      t.timestamps
    end
  end
end
