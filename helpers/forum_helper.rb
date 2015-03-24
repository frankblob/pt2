module ForumHelper
  def topic
  	params[:topic].to_s + '/posts/'
  end

  def menu
  	params[:post] ?  "<h1><a href=\"#{url '/'}\">Forum</a> > <a href=\"#{url '/' + params[:topic]}\" > #{Topic.where(id: params[:topic]).first.title.split(' ')[0]}</a></h1>" : "<h1><a href=\"#{url '/'}\">Forum</a> > #{Topic.where(id: params[:topic]).first.title.split(' ')[0]}</h1>"
  end
end
