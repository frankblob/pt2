require './config'
map('/') 				{ run ApplicationController }
map('/forum') 	{ run ForumController }
map('/search') 	{ run SearchController }
