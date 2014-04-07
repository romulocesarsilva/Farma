#encoding: utf-8
class Team
  include Mongoid::Document
  include Mongoid::Timestamps

  field :code, :type => String
  field :name, :type => String
  field :owner_id, :type => Moped::BSON::ObjectId
  field :available, type: Boolean, default: true

  index({ available: 1}, {background: true})

  attr_accessible :name, :code, :owner_id, :lo_ids, :available

  has_and_belongs_to_many :los
  has_and_belongs_to_many :users, order: "name ASC"

  has_many :answers, class_name: "Answers::Soluction" # For see the answers a long term

  validates_presence_of :name, :code
  validates_uniqueness_of :name

  before_destroy :allow_destroy

  scope :available, where(available: true)

  def owner
    @owner ||= User.find(self.owner_id)
  end

  def enroll(user, code)
    if self.owner_id == user.id
      self.errors.messages[:enroll] = [I18n.translate('mongoid.errors.messages.not_allowed')]
      return false
    end
    if code == self.code
      self.errors.messages.delete :enroll
      unless self.users.include?(user)
        self.users << user
        self.save
      end
      return true
    else
      self.errors.messages[:enroll] = [I18n.translate('mongoid.errors.messages.invalid')]
      return false
    end
  end

  # Return scope not the records
  def self.search(search)
    if search
      available.any_of(:name => /.*#{search}.*/i).desc(:created_at)
    else
      available.desc(:created_at)
    end
  end

  # Return the team ids where the user is owner or
  # enrolled in a team
  def self.ids_by_user(user)
    Team.or({owner_id: user.id} , {user_ids: user.id}).distinct(:id)
  end

  # Return the team ids where the user is
  # enrolled
  def self.ids_enrolled_by_user(user)
    Team.where(user_ids: user.id).distinct(:id)
  end

  # Return the team ids created by a user
  def self.ids_created_by_user(user)
    Team.where(owner_id: user.id).distinct(:id)
  end

private
  def allow_destroy
    can_destroy = users.empty?
    errors.add(:base, "Você não pode deletar essa turma! Pois já possui alunos vinculados") unless can_destroy
    can_destroy
  end

end
