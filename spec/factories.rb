FactoryGirl.define do
  trait :without_api_key do
    api_key nil
  end

  trait :invalid do
    params { {} }
  end

  sequence :uuid do
    Bongloy::SpecHelpers::ApiHelpers.new.generate_uuid
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
      id { generate(:uuid) }
    end

    trait :with_optional_params do
    end

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

    trait :with_id do
      id { generate(:uuid) }
    end

    trait :with_source do
      source { generate(:uuid) }
    end

    trait :with_optional_params do
      email "someone@example.com"
      description "some description"
    end

    trait :invalid do
      with_source # the token will not be valid
    end
  end

  factory :card, :class => Bongloy::ApiResource::Card do
    skip_create
    customer { generate(:uuid) }
    with_source

    params { {} }

    initialize_with { new(customer, params) }

    trait :with_id do
      id { generate(:uuid) }
    end

    trait :with_source do
      source { generate(:uuid) }
    end

    trait :invalid

    trait :with_optional_params do
      params { Bongloy::SpecHelpers::ApiHelpers.new.card_params }
    end
  end

  factory :charge, :class => Bongloy::ApiResource::Charge do
    skip_create

    trait :with_id do
      id { generate(:uuid) }
    end

    trait :with_source do
      source { generate(:uuid) }
    end

    trait :without_source do
      source nil
    end

    trait :with_customer do
      customer { generate(:uuid) }
    end

    trait :with_optional_params do
      capture "false"
      description "some description"
    end

    params { Bongloy::SpecHelpers::ApiHelpers.new.charge_params }
    initialize_with { new(params) }
  end
end
