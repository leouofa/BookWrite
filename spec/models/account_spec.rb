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
  end

  describe 'friendly_id' do
    it 'generates a slug from the name' do
      account = Account.create!(name: 'Slug Test')
      expect(account.slug).to eq('slug-test')
    end

    it 'updates the slug when the name changes' do
      account = Account.create!(name: 'Old Name')
      account.update!(name: 'New Name')
      expect(account.slug).to eq('new-name')
    end

    it 'can find a record by its slug' do
      account = Account.create!(name: 'Findable Account')
      found_account = Account.friendly.find('findable-account')
      expect(found_account).to eq(account)
    end
  end
end
