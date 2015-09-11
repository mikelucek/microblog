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
	User.create(name: @name, email: @email, password: @password)
	redirect "/signin"
	
end

get '/signin' do
	erb :signin
end

post "/process-signin" do
	@u = User.where(name: params[:name]).first
	if @u.password == params[:password]
		session[:user_id] = @u.id
		current user
		redirect "/posts"
	else
		redirect '/signin'
	end
end

get '/showusers' do
	@users = User.all
	erb :showusers
end


#
#
#
#posts landing page
#
#
# current_user
get "/posts" do
	if !currentuser.nil?
		erb :welcome
	else
		erb :signin
	end
	### user can enter posts here. 
	### if session user_id isn't set, kick them back to signin
	### if it is set, welcome them by name
end

post "/create-posts" do
	if !currentuser.nil?
		#make 'em if you got 'em!
	else
		erb :signin
	end
end





