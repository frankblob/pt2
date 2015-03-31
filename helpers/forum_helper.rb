module ForumHelper
  def menu
  	@post ?  "<h1><a href=\"#{url '/'}\">Forum</a> > <a href=\"#{url '/topic/' + @post.topic_id.to_s}\" > #{Topic.where(id: @post.topic_id).first.title.split(' ')[0]}</a> > #{@post.title.split(' ')[0]}...</h1>" : "<h1><a href=\"#{url '/'}\">Forum</a> > #{Topic.where(id: params[:topic]).first.title.split(' ')[0]}</h1>"
  end
end
