class PostsTable < ActiveRecord::Migration
  def change
  	create_table :posts do |x|
  		x.string :post
  		x.integer :user_id
  	end

  end
end
