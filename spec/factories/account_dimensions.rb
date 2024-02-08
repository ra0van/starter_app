FactoryBot.define do
  factory :account_dimensions do
    id { |n| "A#{n}" }
    name { 'test account' }
    currency { 'INR' }
    stop_date { DateTime.now }
    users
  end

  factory :users do
    username { 'u1' }
    fb_user_account_id { 'fb_u1' }
    fb_access_token { 'token' }

    factory :users_with_account_dimensions do
      transient do
        accounts_count { 1 }
      end

      after(:create) do |users, evaluator|
        create_list(:account_dimensions, evaluator.accounts_count, users: users)
        users.reload
      end
    end
  end
end
