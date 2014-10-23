class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def index
  	@users = User.all
  end

  def suspend
  	@user = User.find(params[:id])
  	@user.suspend
  	redirect_to root_path, notice: "Your account has been suspended"
  end
end
