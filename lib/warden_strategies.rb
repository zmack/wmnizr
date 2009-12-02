class Warden::Serializers::Session
  def serialize(user)
    user.nil? ? nil : user.id
  end

  def deserialize(id)
    id.nil? ? nil : User.get(id)
  end
end

Warden::Strategies.add(:bcrypt_password) do
  def valid?
    params["login"] && params["password"]
  end

  def authenticate!
    u = User.find_by_login_and_password(params["login"], params["password"])

    u.nil? ? fail!("Could not log in") : success!(u)
  end
end
