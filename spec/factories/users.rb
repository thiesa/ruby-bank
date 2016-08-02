FactoryGirl.define do
  faked_password = Faker::Internet.password

  factory :user do
    email Faker::Internet.email
    password faked_password
    password_confirmation faked_password

    factory :admin do
      after(:create) { |user| user.add_role(:admin) }
    end

    factory :account do
      after(:create) { |user| user.add_role(:account) }
    end
  end

end
