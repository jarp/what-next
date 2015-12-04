class Story < ActiveRecord::Base
  has_many :subscriptions, dependent: :destroy
  has_many :users, through: :subscriptions, dependent: :destroy
  has_many :chapters, dependent: :destroy

  belongs_to :user

  validates :name, presence: true
  validates :name, uniqueness: true

  scope :available_for, -> (user) { where.not(id: user.stories.map(&:id)) }
  scope :by_activity, -> { order('updated_at desc') }

  has_permalink :name

  def to_s
    name
  end

end
