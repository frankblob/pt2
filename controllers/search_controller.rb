require_relative 'application_controller'

class SearchController < ApplicationController

  Que.mode = :async

  get '/?' do
  	@title = "Search"
    erb :search
  end

  get '/noway/?' do
  	error(401) unless authenticated(User)
    erb :search_noway
  end

  get '/mailer/:id/?' do
  	DB.transaction do
  		email = User.where(id: params[:id]).first.email
  		SignupConfirmation.enqueue(email)
		end	  
	  redirect url '/'
	end

	get '/updatetest/:id/?' do
		DB.transaction do
  		user_id = params[:id]
  		UpdateTest.enqueue(user_id)
		end	  
	  redirect url '/'
	end

end

class UpdateTest < Que::Job

	def run(user_id)
		user = User.where(id: user_id).first
		DB.transaction do
			user.update(name: "Updated")
			destroy
		end
	end

end

class SignupConfirmation < Que::Job

	require 'net/smtp'

	def run(to)
		subject = "Welcome to #{ENV['SITENAME']} - signup complete!"
		body = "Welcome to #{ENV['SITENAME']} - I'm glad to have you on board!\n\nYou have successfully signed up and everything is ready to go.\n\nAnd that's very cool.\n\nGo to #{ENV['SITE_URL']} and set up your first pushtorrent.\n\nSee you soon.\n\n\nRegards,\n\nFrank, the friendly mail robot at #{ENV['SITENAME']}\n\n**********************************\nThis email was automatically generated. Do not reply to this email adress. Instead, if you have questions, feedback or suggestions, please go to #{ENV['SITE_URL']}/contact\n**********************************"
		message = composer(to, subject, body)
		sendit!(to, message)
		DB.transaction do
			destroy
		end
	end

	def composer(to, subject, body)
		from = ENV['MAIL_FROM']
		to = to
		message = "From: #{ENV['SITENAME']} - NO REPLY/AUTO-EMAIL <#{from}>\nTo: #{to}\nSubject: #{subject}\n\n#{body}"
	end

	def sendit!(to, message)
		smtp = Net::SMTP.new('smtp.gmail.com', 587)
		smtp.enable_starttls
		smtp.start('gmail.com', ENV['MAIL_FROM'], ENV['MAIL_PASS'], :plain) do |smtp|
			smtp.send_message(message, ENV['MAIL_FROM'], to)
		end
	end
end
