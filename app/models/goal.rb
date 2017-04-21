class Goal < ApplicationRecord
  validates :title, :description, :user_id, :target_date, presence: true

  belongs_to :user,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: 'User'

end
