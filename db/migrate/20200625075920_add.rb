class Add < ActiveRecord::Migration[5.2]
  def change
    create_table :savelistspointers do |t|
      t.references  :savelist, foreign_key: true
      t.references  :service, foreign_key: true
      t.timestamps
    end
  end
end
