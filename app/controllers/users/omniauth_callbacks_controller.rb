class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.from_omniauth(request.env["omniauth.auth"])
    @user.set_token(request.env["omniauth.auth"])

    if @user.persisted?
      if @user.is_dev_team?
        sign_in_and_redirect @user, :event => :authentication # this will throw if @user is not activated
        set_flash_message(:notice, :success, :kind => "Github") if is_navigational_format?
      else
        reject_login
      end
    else
      reject_login
    end
  end

  def reject_login
    session["devise.github_data"] = request.env["omniauth.auth"]
    redirect_to root_path, notice: "You need to be a member of the wcmc-core-dev group on github to be authorized to access this page."
  end
end