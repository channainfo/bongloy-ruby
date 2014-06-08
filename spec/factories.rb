FactoryGirl.define do
  trait :without_api_key do
    api_key nil
  end

  trait :invalid do
    params { {} }
  end

  sequence :token_id do |n|
    Bongloy::SpecHelpers::ApiHelpers.new.sample_token_id(n)
  end

  factory :token, :class => Bongloy::ApiResource::Token do
    trait :with_id do
      invalid
      id { generate(:token_id) }
    end

    skip_create
    params { Bongloy::SpecHelpers::ApiHelpers.new.credit_card_token_params }
    initialize_with { new(params) }
  end

  factory :publishable_api_key, :class => Bongloy::ApiKey::Publishable do
    skip_create
    api_key { "pk_test_some_api_key" }
    initialize_with { new(api_key) }
  end

  factory :customer, :class => Bongloy::ApiResource::Customer do
    skip_create

    trait :with_card do
      card { generate(:token_id) }
    end
  end
end
