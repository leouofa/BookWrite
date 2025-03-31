FactoryBot.define do
  factory :membership do
    association :user
    association :account
    owner { false }

    trait :as_owner do
      owner { true }
    end
  end
end
