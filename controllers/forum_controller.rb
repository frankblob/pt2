require_relative 'application_controller'

class ForumController < ApplicationController

  helpers ForumHelper

  get '/?' do
    @posts = Post.limit(20).all.sort_by(&:updated_at).reverse
    #eager-load @post.comments.count
    #eager-load post.comments.last
    erb :forum_index
  end

  get '/topic/:topic/?' do
    @posts = Post.where(topic_id: params[:topic]).all.sort_by(&:updated_at).reverse
    #eager-load @post.comments.count
    #eager-load @post.comments.last
    erb :topic_index
  end

  get '/posts/new/?' do
     erb :post_new
  end

  get '/posts/:post/?' do
    @post = Post.where(id: params[:post]).first
    #eager-load @post.comments.count
    #eager-load @post.comments
    erb :post_show
  end

  post '/?' do
    post = Post.new(params[:post])
    if post.save
      redirect to "/posts/#{post.id.to_s}"
    else
      erb :post_new
    end
  end

  get '/posts/:id/edit/?' do
    @post = Post[params[:id]]
    erb :post_edit
  end

  put '/posts/:id/?' do
    post = Post[params[:id]]
    if post.update(params[:post])
      #redirect url "/posts/#{post.id.to_s}"
      redirect url '/posts/' + post.id.to_s
    else
      redirect back
    end
  end

  delete '/posts/:id/?' do
    Post[params[:id]].destroy
    redirect url '/'
  end

end 
