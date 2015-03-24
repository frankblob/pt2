class Post < Sequel::Model
  one_to_many :comments
  many_to_one :topic
  many_to_one :user
  def validate
    super
    validates_presence :title, :message=>"you need a title for the category to proceed"
    validates_presence :body, :message=>"you need some text for the post to proceed"
    validates_presence :topic_id, :message=>"you need to add specify the topic_id for this post"
    validates_presence :user_id, :message=>"you need to specify the user_id for this post"
  end
end
