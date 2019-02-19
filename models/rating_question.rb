
class RatingQuestion
  include Mongoid::Document
  include Mongoid::Timestamp

  field :title

  validates :title, presence: true
end
