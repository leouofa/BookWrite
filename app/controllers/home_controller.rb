class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.memberships.exists?
      # If user has memberships, show the accounts index
      redirect_to accounts_path
    else
      # If user has no memberships, show new account form
      redirect_to new_account_path
    end
  end
end
