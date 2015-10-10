class User < ActiveRecord::Base
	has_many :posts, dependent: :destroy
	has_many :friendships, dependent: :destroy
	has_many :friends, :through => :friendships
end

class Post < ActiveRecord::Base
	belongs_to :user
end

class Friendship < ActiveRecord::Base
	belongs_to :user
	belongs_to :friend, :class_name => "User"
end



