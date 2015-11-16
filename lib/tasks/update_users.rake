task :update_users => :environment do
  @users = User.all
  @users.each do |user|
    response = HTTParty.get(
      "#{Rails.application.secrets.github_api_base_url}users/#{user.github}?access_token=#{user.token}",
      headers: {"User-Agent" => "Labs"}
    )
    response_hash = JSON.parse(response.body)
    user.update_attributes({name: response_hash["name"]})
  end
end
