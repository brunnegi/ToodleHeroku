class Trip < ActiveRecord::Base
  attr_accessible :details, :dpoi, :end_date, :name, :owner, :participants, :poi, :start_date
  belongs_to :user, foreign_key: "owner"
  has_many :pois
#  def part_ids
#	return participants.split(",")
#  end
  def participants_ids_array
    @parts=participants.split(',')
    @ret=Array.new
	@parts.each do |part|
	  	  @ret.push(part.to_i)
	end
    return @ret
  end
  
  def participates_id?(id)
    return participants_ids_array.include? id
  end
end
