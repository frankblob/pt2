DB.extension(:constraint_validations)
DB.create_constraint_validations_table

#uncomment models/init.rb to enable auto-sync with DB contraints

DB.create_table :users do 
  primary_key :id
  column :email, String, null: false
  column :crypted_password, String, null: false
  column :name, String
  column :type, String, :default=>"1", null: false
  column :created_at, DateTime
  column :updated_at, DateTime
  index :email, :unique=>true
  validate do
    min_length 5, :email
    format /.+@.+\..+/i, :email
    format /^[012]/, :type
  end
end

DB.create_table :topics do
  primary_key :id
  String :title, null: false
  foreign_key :user_id, :users
  DateTime :created_at
  DateTime :updated_at
end

DB.create_table :posts do
  primary_key :id
  String :title, null: false
  String :body, text: true, null: false
  foreign_key :topic_id, :topics, null: false
  foreign_key :user_id, :users
  DateTime :created_at
  DateTime :updated_at
  index :topic_id
end

DB.create_table :comments do
  primary_key :id
  String :body, text: true, null: false
  foreign_key :post_id, :posts, null: false
  foreign_key :user_id, :users
#  foreign_key :comment_id, :comments
  DateTime :created_at
  DateTime :updated_at
  index :post_id
end
