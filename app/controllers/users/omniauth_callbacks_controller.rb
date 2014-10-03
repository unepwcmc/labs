class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    # # TODO - You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])
    @user.set_token(request.env["omniauth.auth"])

    if @user.persisted?
        @user.check_if_unep
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, :kind => "Github") if is_navigational_format?
    else
        session["devise.github_data"] = request.env["omniauth.auth"]
        redirect_to root, notice: "You need to be a member of the WCMC github to sign in."
    end
  end
end