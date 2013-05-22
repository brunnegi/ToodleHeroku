# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
 require 'will_paginate/array' #hotfix for trips to be paginated
 
class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :twitter_acc, :access_token, :access_token_secret
  has_secure_password
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  
  has_many :owned_trips, class_name: "Trip" , :foreign_key => "owner", dependent: :destroy
#  has_many :trips, :foreign_key => "part_ids"

  def trips
	@ret=Array.new
	@tripsfor=Trip.all
	@tripsfor.each do |tripfor|
	  @parts = tripfor.participants.split(',')
	  @parts.each do |part|
	    if part.to_i == id
	  	  @ret.push(tripfor)
	    end
	  end
	end
    return @ret
  end

  
#  has_many :trips, :foreign_key => "participants.split(',')"
#  has_many :trips, :foreign_key => "owner", dependent: :destroy
#  has_many :part_trips, cluseruserass_name: "trip" , :foreign_key => "part_ids"
  
  before_save {|user| user.email =email.downcase}
  before_save :create_remember_token
  
  validates :name, presence:true, length:{maximum:30}
   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive:false}
  validates :password, presence:true, length:{minimum:6}
  validates :password_confirmation, presence:true
  
  def feed
  	Micropost.from_users_followed_by(self)
  end
  
  def following?(other_user)
  	relationships.find_by_followed_id(other_user.id)
  end
  
  def follow!(other_user)
  	relationships.create!(followed_id: other_user.id)
  end
  
  def unfollow!(other_user)
  	relationships.find_by_followed_id(other_user.id).destroy
  end
  
  private 
  
  	def create_remember_token
  		self.remember_token = SecureRandom.urlsafe_base64
  	end
  
end
