FactoryBot.define do
  factory :membership do
    user { nil }
    account { nil }
    owner { false }
  end
end
