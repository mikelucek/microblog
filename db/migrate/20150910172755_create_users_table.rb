class CreateUsersTable < ActiveRecord::Migration
  def change
  	create_table :users do |x|
  		x.string :name
  		x.string :password
  		x.string :email
  	end
  end
end
