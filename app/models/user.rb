class User < ActiveRecord::Base
  has_many :subscriptions, dependent: :destroy
  has_many :stories, through: :subscriptions, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments
  # before_destroy :delete_owned_stories

  validates :first_name, :last_name, :email, presence: true

  default_scope {where(deleted: false).order('last_name, first_name')}
  scope :active, -> { where(active:true) }
  scope :authors, -> { joins(:subscriptions).where("subscriptions.author = true") }
  scope :with_email_notifications, -> { joins(:subscriptions).where("subscriptions.send_email = true").distinct }
  scope :privileged, -> { where(privileged:true) }

  def to_s
    full_name
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def authored_stories
    stories = []
    s = subscriptions.where(author: true)
    s.each { |sub| stories << sub.story }
    return stories
  end

  def available_stories
    Story.all.where.not(id: stories)
  end

  def subscribe_to(story, username, options={})
    @options = {author: false, privileged: false, send_email: true}.merge(options)
    @subscription = Subscription.create(story:story, user: self, username: username,  author: @options[:author], privileged: @options[:privileged], send_email: @options[:send_email])
  end

  def delete_owned_stories
    Story.where(user: self).destroy_all
  end

  def delete
    self.deleted=true
    self.save
  end

end
