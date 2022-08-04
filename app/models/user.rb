require "bcrypt"

class User < ApplicationRecord
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :getalibrarycard_authenticatable, :timeoutable,
    :omniauthable, omniauth_providers: %i[keycloakopenid]

  attr_accessor :username, :password

  def self.from_omniauth(auth)
    user = find_or_initialize_by(provider: auth.provider, uid: auth.uid)
    user.email = auth.info.email
    user.encrypted_password = Devise::Encryptor.digest(user.class, Devise.friendly_token(20))
    user.name_given = auth.info.first_name
    user.name_family = auth.info.last_name

    user.save
    user
  end

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    "#{name_given} #{name_family}"
  end

  def pepper
    "au.gov.nla.blacklight"
  end
end
