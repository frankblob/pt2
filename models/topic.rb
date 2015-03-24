class Topic < Sequel::Model
  one_to_many :posts
  many_to_one :user
  def validate
    super
    validates_presence :title, :message=>"you need a title for the category to proceed"
    validates_presence :user_id, :message=>"you need to specify a user_id for this topic"
  end
end
