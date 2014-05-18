FactoryGirl.define do
  trait :without_api_key do
    api_key nil
  end

  trait :invalid do
    params { {} }
  end

  factory :token, :class => Bongloy::ApiResource::Token do
    skip_create
    params { Bongloy::SpecHelpers::ApiHelpers.new.credit_card_token_params }
    initialize_with { new(params) }
  end

  factory :publishable_api_key, :class => Bongloy::ApiKey::Publishable do
    skip_create
    api_key { "pk_test_some_api_key" }
    initialize_with { new(api_key) }
  end
end
