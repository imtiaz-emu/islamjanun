class User < ActiveRecord::Base

  has_and_belongs_to_many :roles
  has_one :profile, dependent: :destroy
  has_many  :questions, :dependent => :destroy
  has_many  :answers, :dependent => :destroy
  has_many  :upvotes, :dependent => :destroy
  has_many  :downvotes, :dependent => :destroy
  has_many  :comments, :dependent => :destroy

  after_create :assign_member_role
  after_create :create_profile
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  attr_accessor :role_id

  def role?(role)
    !!self.roles.find_by_name(role.to_s.camelize)
  end

  def is_admin?
    self.role?(:super_admin)
  end

  def is_moderator?
    self.role?(:moderator)
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    provider = access_token.provider
    uid = access_token.uid

    user = User.where(:provider => provider, :uid => uid).first

    # Uncomment the section below if you want users to be created if they don't exist
    unless user

      user                          = self.new
      user.first_name               = data['first_name']
      user.last_name                = data['last_name']
      user.email                    = data['email']
      user.provider                 = provider
      user.uid                      = uid
      user.password                 = Devise.friendly_token[0,20]

      user.save(validate: true)
    end
    user
  end

  def self.from_twitter_omniauth(access_token)
    data = access_token.info
    provider = access_token.provider
    uid = access_token.uid

    user = User.where(:provider => provider, :uid => uid).first

    # Uncomment the section below if you want users to be created if they don't exist
    unless user

      first_name, last_name = get_first_and_last_name(access_token)

      user                          = self.new
      user.first_name               = first_name
      user.last_name                = last_name
      user.email                    = last_name + first_name + '@railspack.com'
      user.provider                 = provider
      user.uid                      = uid
      user.password                 = Devise.friendly_token[0,20]

      user.save(validate: false)
    end
    user
  end

  def self.create_from_omniauth_facebook(auth)

    first_name, last_name = get_first_and_last_name(auth)

    user                          = self.new
    user.first_name               = first_name
    user.last_name                = last_name
    user.provider                 = auth['provider']
    user.uid                      = auth['uid']
    user.password                 = Devise.friendly_token[0,20]

    user.save(validate: true)
    user
  end

  def self.get_first_and_last_name(auth)
    name = auth['info']['name'].split(/ /)
    length = name.length
    if length > 1
      last_name = name.pop(1).join(' ')
      first_name = name.join(' ')
    else
      first_name = auth['info']['name']
      last_name = ''
    end
    return first_name, last_name
  end

  def email_required?
    false
  end

  def add_role_by_admin(role_id)
    self.roles.destroy_all
    if role_id.nil?
      self.roles << Role.last
    else
      self.roles << Role.find(role_id)
    end
  end

  private
  def assign_member_role
    RolesUsers.create!(role_id: Role::USER_ROLE[:member], user_id: self.id)
    new_first_name = self.email.split("@")[0] + self.id.to_s
    self.update_column(:first_name, new_first_name)
  end
end
