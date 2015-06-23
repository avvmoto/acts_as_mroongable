class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :abstract

      t.timestamps
    end
  end
end
