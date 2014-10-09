require 'test_helper'

class SuspendUsersTest < ActionDispatch::IntegrationTest
  test "clicking suspend user marks them as suspended" do
    visit users_path
    page.has_content? "Gravatar"
    puts "huururrrr"
  end
end
