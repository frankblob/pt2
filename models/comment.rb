class Comment < Sequel::Model
  many_to_one :post
  many_to_one :user
  def validate
    super    
    validates_presence :body, :message=>"you need some text for the comment to proceed"
    validates_presence :post_id, :message=>"you need to specify the post_id for this comment"
    validates_presence :user_id, :message=>"you need tp specify the user_id for this comment"
  end
end
