require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:memberships).dependent(:destroy) }
    it { should have_many(:accounts).through(:memberships) }
  end

  describe '#owner_of?' do
    let(:user) { create(:user) }
    let(:owned_account) { create(:account) }
    let(:member_account) { create(:account) }
    let(:unrelated_account) { create(:account) }

    before do
      create(:membership, user: user, account: owned_account, owner: true)
      create(:membership, user: user, account: member_account, owner: false)
      create(:membership, user: create(:user), account: unrelated_account, owner: true)
    end

    it 'returns true if the user is an owner of the account' do
      expect(user.owner_of?(owned_account)).to be true
    end

    it 'returns false if the user is a member but not an owner of the account' do
      expect(user.owner_of?(member_account)).to be false
    end

    it 'returns false if the user is not associated with the account' do
      expect(user.owner_of?(unrelated_account)).to be false
    end
  end
end
