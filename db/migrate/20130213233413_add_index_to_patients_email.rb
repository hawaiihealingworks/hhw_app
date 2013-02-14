class AddIndexToPatientsEmail < ActiveRecord::Migration
  def change
  	add_index :patients, :email, unique: true
  end
end
