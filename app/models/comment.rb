class Comment < ActiveRecord::Base
  belongs_to :chef 
  belongs_to :recipe 
  validates :comment, presence: true, length: {minimum: 5, maximum: 2500}
  validates :chef_id, presence: true
  default_scope -> { order(updated_at: :desc)}
end
