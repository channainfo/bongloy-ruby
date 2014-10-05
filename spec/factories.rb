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

  factory :error, :class => Bongloy::Error::Api::BaseError do
    skip_create

    factory :invalid_request_error,          :class => Bongloy::Error::Api::InvalidRequestError
    factory :authentication_error,           :class => Bongloy::Error::Api::AuthenticationError
    factory :not_found_error,                :class => Bongloy::Error::Api::NotFoundError
  end

  factory :token, :class => Bongloy::ApiResource::Token do
    skip_create

    trait :with_id do
      invalid
      id { generate(:token_id) }
    end

    trait :with_optional_params

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

    trait :invalid do
      with_card # the token will not be valid
    end
  end

  factory :charge, :class => Bongloy::ApiResource::Charge do
    skip_create

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
      capture "false"
      description "some description"
    end

    params { Bongloy::SpecHelpers::ApiHelpers.new.charge_params }
    initialize_with { new(params) }
  end
end
