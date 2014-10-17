module ApplicationHelper
  def gravatar user
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      "http://gravatar.com/avatar/#{gravatar_id}.png?s=60"
  end
end
