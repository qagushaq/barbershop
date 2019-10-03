require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

get '/' do
	erb "Hello!
	<a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a>
	pattern has been modified for <a href=\"https://vk.com/chelo_vek\">Alexey Lukashevich</a>"
end

get '/about' do
	@error = 'Something went wrong!'
	erb :about
end

def get_db
	return SQLite3::Database.new 'barbershop.db'
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS "Users"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"username" TEXT,
			"useremail" TEXT,
			"phonenumber" TEXT,
			"datetime" TEXT,
			"barber" TEXT,
			"color" TEXT
		)'
	db.close
end

get '/visit' do
  erb :visit
end

post '/visit' do
	@username = params[:username]
	@useremail = params[:useremail]
	@phonenumber = params[:phonenumber]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]

	hh = { :username => 'name',
	:useremail => 'email',
  :phonenumber => 'phonenumber',
  :datetime => 'the date and time when you come to us :)' }

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
	  return erb :visit
	end

	db = get_db
	db.execute 'INSERT into Users (username, useremail, phonenumber,datetime, barber, color)
		VALUES (?, ?, ?, ?, ?,?)', [@username,@useremail,@phonenumber,@datetime,@barber,@color]
	@title = "Thank you! We are waiting for you!"
	@message = "Dear #{@username}, we are wating you at #{@datetime}. We are call back to the number: #{@phonenumber} or write to the email: #{@useremail} for details. Color: #{@color} Barber: #{@barber}"
	erb :message
	db.close
end

get '/admin' do
  erb :admin
end

post '/admin' do
  @login = params[:login]
  @password = params[:password]
  if @login == 'admin' && @password == '1'
		@file = File.open("./public/clients.txt","r")
		 erb :contacts
  else
    @report = '<p>Доступ запрещён! Неправильный логин или пароль.</p>'
    erb :admin
  end
end
