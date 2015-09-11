class JoinTable < ActiveRecord::Migration
  def change
  	create_table :friendships do |x|
  		x.integer :user_id
  		x.integer :friend_id
  	end
  end
end
