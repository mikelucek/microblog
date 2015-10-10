require "sinatra"
require "sinatra/activerecord"

configure (:development){set :database, "sqlite3:test.sqlite3"}

set :sessions, true
require "./models"
###########################################################

def current_user
	if session[:user_id]
		@current_user = User.find(session[:user_id])
	end
	
end

def user_name
	if @current_user
		@current_user.name
	end
end

def show_users
	if !current_user.nil?
		#let's build a list of all current friends, in order to unfollow.
		#then let's build a lits of all users EXCEPT current friends, in order to follow
		@all_users = User.all
		@friends = @current_user.friends.all
		@unfollowed_users = @all_users - @friends
		puts "**********I*AM"
		puts @current_user.name
		puts "****************************FRIENDS"
		puts @friends
		puts "**********UNFOLLOWEDS"
		puts @unfollowed_users
		@result = "<ul>"
		@unfollowed_users.each do |x|
			@result = @result + "<li>" + x.name + " " + "<a href = 'follow/" + x.id.to_s + "''>follow</a></li>"
		end
		@friends.each do |x|
			@result = @result + "<li>" + x.name + " " + "<a href = 'unfollow/" + x.id.to_s + "''>unfollow</a></li>"
		end
	@result = @result + "</ul>"
	@result
	else
		redirect "/signin"
	end
end

#build <ul> of posts
def show_posts(id)
	@posts = User.find(id).posts.reverse_order
	@name = User.find(id).name.upcase
	@result = "<ul>"
	@result = @result + "posts from " + @name
	@posts.each do |x|
		@result = @result + "<li>" + x.post + "</li>"
	end
	@result = @result + "</ul>"
	@result
end

def show_my_posts_and_followeds_posts
	if !current_user.nil?
			 @r = show_posts(@current_user.id)
			@current_user.friends.each do |x|
				@r = @r + show_posts(x.id)
			end
			@r
		else
			redirect "/signin"
		end
end


#############################################################

get '/' do
	erb :home
end

get '/signup' do
	erb :signup
end

post '/process-signup' do
	@name = params[:name]
	@email = params[:email]
	@password = params[:password]
	@u = User.create(name: @name, email: @email, password: @password)
	session[:user_id] = @u.id
	current_user
	redirect "/posts"
end

get '/signin' do
	erb :signin
end

get '/signout' do
	session[:user_id] = nil
	redirect '/'
end

post "/process-signin" do
	@u = User.where(name: params[:name]).first
	if @u.password == params[:password]
		session[:user_id] = @u.id
		current_user
		redirect "/posts"
	else
		redirect '/signin'
	end
end

get "/profile" do
	if !current_user.nil?
		erb :profile
	else
		"/signin"
	end
end

post "/process-edit" do
	@u = User.where(id: session[:user_id]).first
	@u.update(name: params[:name], email: params[:email], password: params[:password])
	current_user
	redirect "/posts"
end

get "/delete" do
	@u = User.where(id: session[:user_id]).first
	@u.destroy
	session[:user_id] = nil
	current_user
	redirect "/"
end




#
#
#
#posts landing page
#
#
# current_user
get "/posts" do
	if !current_user.nil?
		erb :posts
	else
		erb :signin
	end
	### user can enter posts here. 
	### if session user_id isn't set, kick them back to signin
	### if it is set, welcome them by name
end

post "/create-post" do
	if !current_user.nil?
		Post.create(post: params[:post], user_id: @current_user.id)
		##flash here to indicate success.
		erb :posts
	else
		erb :signin
	end
end

get "/show-users" do
	if !current_user.nil?
		erb :showusers
	else
		erb :signin
	end
end

get "/follow/:id" do
	if !current_user.nil?
		Friendship.create(user_id: @current_user.id, friend_id: params[:id])
		redirect "/show-users"
	else
		redirect "/signin"
	end
		
end

get "/unfollow/:id" do
	if !current_user.nil?
		@f = Friendship.where(user_id: @current_user.id, friend_id: params[:id]).first
		@f.destroy
		redirect "/show-users"
	else
		redirect "/signin"
	end
end







