require 'rails_helper'

RSpec.describe Membership, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:account) }
  end

  describe 'validations' do
    it 'validates uniqueness of user_id scoped to account_id' do
      user = create(:user)
      account = create(:account)
      create(:membership, user: user, account: account)

      duplicate_membership = build(:membership, user: user, account: account)

      expect(duplicate_membership).not_to be_valid
      expect(duplicate_membership.errors[:user_id]).to include("is already a member of this account")
    end
  end

  describe 'prevent_destroying_last_owner callback' do
    let(:account) { create(:account) }
    let(:user) { create(:user) }

    context 'when attempting to destroy the only owner' do
      let!(:owner_membership) { create(:membership, user: user, account: account, owner: true) }

      it 'prevents the destruction' do
        expect { owner_membership.destroy }.not_to change(Membership, :count)
      end

      it 'adds an error message' do
        owner_membership.destroy
        expect(owner_membership.errors[:base]).to include("Cannot remove the only owner of an account")
      end
    end

    context 'when there are multiple owners' do
      let!(:first_owner_membership) { create(:membership, user: user, account: account, owner: true) }
      let!(:second_owner_membership) { create(:membership, user: create(:user), account: account, owner: true) }

      it 'allows the destruction' do
        expect { first_owner_membership.destroy }.to change(Membership, :count).by(-1)
      end
    end

    context 'when the membership is not an owner' do
      let!(:owner_membership) { create(:membership, user: create(:user), account: account, owner: true) }
      let!(:regular_membership) { create(:membership, user: user, account: account, owner: false) }

      it 'allows the destruction' do
        expect { regular_membership.destroy }.to change(Membership, :count).by(-1)
      end
    end
  end
end
