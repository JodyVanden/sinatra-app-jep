
class RatingQuestion
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :tag

  validates :title, presence: true
end
