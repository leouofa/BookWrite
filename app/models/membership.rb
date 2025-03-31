class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :account

  validates :user_id, uniqueness: { scope: :account_id, message: "is already a member of this account" }

  before_destroy :prevent_destroying_last_owner

  private

  def prevent_destroying_last_owner
    if owner && account.memberships.where(owner: true).count == 1
      errors.add(:base, "Cannot remove the only owner of an account")
      throw :abort
    end
  end
end
