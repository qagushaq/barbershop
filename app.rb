#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
	erb "Hello!
	<a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a>
	pattern has been modified for <a href=\"https://vk.com/chelo_vek\">Alexey Lukashevich</a>"
end

get '/about' do
  erb :about
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
	@title = "Thank you! We are waiting for you!"
	@message = "Dear #{@username}, we are wating you at #{@datetime}. We are call back to the number: #{@phonenumber} or write to the email: #{@useremail} for details. Color: #{@color} Barber: #{@barber}"
	f = File.open './public/clients.txt', 'a'
  f.write "Client: #{@username}, Phone: #{@phonenumber}, Eemail: #{@useremail} , Date and Time: #{@datetime}, Color: #{@color}. Barber: #{@barber}.\n"
  f.close
	erb :message
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
