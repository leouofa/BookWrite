class Account < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, presence: true, uniqueness: true

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  validate :must_have_owner, on: :update

  def owners
    users.joins(:memberships).where(memberships: { owner: true, account_id: id })
  end

  def should_generate_new_friendly_id?
    name_changed? || super
  end

  private

  def must_have_owner
    if persisted? && !memberships.where(owner: true).exists?
      errors.add(:base, "Account must have at least one owner")
    end
  end
end
