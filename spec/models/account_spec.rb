require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'validations' do
    it 'is valid with a name' do
      account = Account.new(name: 'Test Account')
      expect(account).to be_valid
    end

    it 'is invalid without a name' do
      account = Account.new(name: nil)
      expect(account).to_not be_valid
      expect(account.errors[:name]).to include("can't be blank")
    end

    it 'is invalid with a duplicate name' do
      Account.create!(name: 'Duplicate Name')
      account = Account.new(name: 'Duplicate Name')
      expect(account).to_not be_valid
      expect(account.errors[:name]).to include('has already been taken')
    end

    context 'must_have_owner validation' do
      let(:account) { create(:account) }
      let(:user) { create(:user) }
      let!(:membership) { create(:membership, user: user, account: account, owner: true) }

      it 'is valid when it has at least one owner' do
        expect(account).to be_valid
      end

      it 'is invalid when updating and it has no owners' do
        membership.update(owner: false)
        expect(account.reload).not_to be_valid
        expect(account.errors[:base]).to include("Account must have at least one owner")
      end
    end
  end

  describe 'friendly_id' do
    it 'generates a slug from the name' do
      account = Account.create!(name: 'Slug Test')
      expect(account.slug).to eq('slug-test')
    end

    it 'updates the slug when the name changes' do
      account = Account.create!(name: 'Old Name')
      user = create(:user)
      create(:membership, user: user, account: account, owner: true)

      account.update!(name: 'New Name')
      expect(account.slug).to eq('new-name')
    end

    it 'can find a record by its slug' do
      account = Account.create!(name: 'Findable Account')
      found_account = Account.friendly.find('findable-account')
      expect(found_account).to eq(account)
    end
  end

  describe 'associations' do
    it { should have_many(:memberships).dependent(:destroy) }
    it { should have_many(:users).through(:memberships) }
  end

  describe '#owners' do
    let(:account) { create(:account) }
    let(:owner) { create(:user) }
    let(:regular_user) { create(:user) }

    before do
      create(:membership, user: owner, account: account, owner: true)
      create(:membership, user: regular_user, account: account, owner: false)
    end

    it 'returns only users with owner memberships' do
      expect(account.owners).to include(owner)
      expect(account.owners).not_to include(regular_user)
    end
  end
end
