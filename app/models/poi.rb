require 'will_paginate/array' #hotfix for trips to be paginated
require 'flickraw'

class Poi < ActiveRecord::Base
  attr_accessible :description, :image, :image_orig, :location, :name, :trip_id, :definitive, :voters
  belongs_to :trip
  
  
  
  
  
  def voters_array
	@ret=Array.new
	@users=User.all
    @votersarr = voters.split(',')
	@users.each do |userf|
	  @votersarr.each do |voter|
	    if voter.to_i == userf.id
	  	  @ret.push(userf)
	    end
	  end
	end
    return @ret
  end
  
  def voters_id_array
	@ret=Array.new
	@users=User.all
    @votersarr = voters.split(',')
	@users.each do |userf|
	  @votersarr.each do |voter|
	    if voter.to_i == userf.id
	  	  @ret.push(userf.id)
	    end
	  end
	end
    return @ret
  end
end
