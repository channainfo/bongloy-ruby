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

  sequence :customer_id do |n|
    Bongloy::SpecHelpers::ApiHelpers.new.sample_customer_id(n)
  end

  sequence :card_id do |n|
    Bongloy::SpecHelpers::ApiHelpers.new.sample_card_id(n)
  end

  sequence :charge_id do |n|
    Bongloy::SpecHelpers::ApiHelpers.new.sample_charge_id(n)
  end

  factory :client, :class => Bongloy::Client do
    skip_create

    trait :stripe do
      api_endpoint { ENV["STRIPE_API_ENDPOINT"] }
    end
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
    trait :with_id do
      id { generate(:customer_id) }
    end

    trait :with_card do
      card { generate(:token_id) }
    end

    trait :with_optional_params do
      email "someone@example.com"
      description "some description"
    end
  end

  factory :charge, :class => Bongloy::ApiResource::Charge do
    skip_create
    with_card

    trait :with_id do
      id { generate(:charge_id) }
    end

    trait :with_card do
      card { generate(:token_id) }
    end

    trait :without_card do
      card nil
    end

    trait :with_customer do
      customer { generate(:customer_id) }
    end

    trait :with_optional_params do
      capture false
      desription "some description"
    end
  end
end
