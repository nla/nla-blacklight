FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test-#{n.to_s.rjust(3, "0")}@example.com" }
    password { "123456" }

    trait :staff do
      provider { "keycloakopenid" }
      uid { "b8d0e04c-5a33-458f-b917-bc258861ebc0" }
      name_given { "Staff" }
      name_family { "User" }
      email { "staff_user@nla.gov.au" }
    end

    created_at { Time.current }
    updated_at { Time.current }
  end
end
