class Warden::Serializers::Session
  def serialize(user)
    p "----------------"
    p user
    p user.id
    user.nil? ? nil : user.id
  end

  def deserialize(id)
    p "==============#{id}"
    id.nil? ? nil : User.get(id)
  end
end

Warden::Strategies.add(:pickle) do
  def valid?
    p params.inspect
    p params['login']
    params["login"] || params["password"]
  end

  def authenticate!
    p params.inspect
    p params['email']
    u = User.first
    p u
    u.nil? ? fail!("Could not log in") : success!(u)
  end
end
