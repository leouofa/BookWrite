class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, only: [ :show ]

  def index
    @accounts = current_user.accounts
  end

  def show
  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)

    ActiveRecord::Base.transaction do
      if @account.save
        # Create a membership for the user as owner
        Membership.create!(user: current_user, account: @account, owner: true)
        redirect_to @account, notice: "Account was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  private

  def set_account
    @account = Account.friendly.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:name)
  end
end
