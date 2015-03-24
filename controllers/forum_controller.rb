require_relative 'application_controller'

class ForumController < ApplicationController

  helpers ForumHelper

  get '/?' do
    @topics = Topic.all
    #eager-load @topic.posts.count
    #eager-load @topic.posts.comments.count
    #eager-load post.comments.last for display below
    erb :forum_index
  end

  get '/:topic/?' do
    @posts = Post.where(topic_id: params[:topic]).all.sort_by(&:updated_at).reverse
    #eager-load @post.comments.count
    #eager-load @post.comments.last for display below
    erb :topic_index
  end

  get '/:topic/posts/:post/?' do
    @post = Post.where(id: params[:post]).first
    #eager-load @post.comments.count
    #eager-load @post.comments.last for display below
    erb :post_show
  end

  post '/?' do
    post = Post.new(params[:post])
    if post.save
      redirect to "/#{post.id}"
    else
      erb :post_new
    end
  end

  get '/new/?' do
    #@post = Post.new
    erb :post_new
  end

  get '/:id/?' do
    @post = Post[params[:id]]
    #eager-load post.comments
    erb :post_show
  end

  get '/:id/edit/?' do
    @post = Post[params[:id]]
    erb :post_edit
  end

  put '/:id/?' do
    post = Post[params[:id]]
    if post.update(params[:post])
      redirect url '/' + post.id.to_s
    else
      redirect back
    end
  end

  delete '/:id/?' do
    Post[params[:id]].destroy
    redirect url '/'
  end

end 
