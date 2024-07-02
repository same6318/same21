class Label < ApplicationRecord
  has_many :task_label_relations, dependent: :destroy
  has_many :tasks, through: :task_label_relations
  belongs_to :user

  validates :name, presence: true

end
