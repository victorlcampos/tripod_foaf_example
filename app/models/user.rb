class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, omniauth_providers: [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :provider, :uid, :email, :password

  def friends(token)
    @graph ||= Koala::Facebook::API.new(token)
    @graph.get_connections("me", "friends")
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create( provider:auth.provider,
                          uid:auth.uid,
                          email:auth.info.email,
                          password: Devise.friendly_token[0,20]
                        )

      uri = "http://example.com/#{auth.uid}"

      p = Person.new(uri)
      p.name = auth.extra.raw_info.name
      friends = []
      user.friends(auth.credentials.token).each do |friend|
        begin
          p_friend = Person.find("http://example.com/#{friend['id']}")
        rescue
          p_friend = Person.new("http://example.com/#{friend['id']}")
          p_friend.name = friend['name']
          p_friend.save!
        end

        friends << "http://example.com/#{friend['id']}"
      end
      p.knows = friends
      p.save!
    end
    user
  end
end
