# Bongloy

[![Build Status](https://travis-ci.org/dwilkie/bongloy-ruby.svg?branch=master)](https://travis-ci.org/dwilkie/bongloy-ruby)

Consumes the [Bongloy API](https://bongloy.com/documentation#bongloy_api_reference)

## Installation

This gem is still in beta. To install:

Add this line to your application's Gemfile:

```ruby
gem 'bongloy', :github => "dwilkie/bongloy-ruby"
```

And then execute:

```
$ bundle
```

## Usage

### Full API Documentation

The [Bongloy API](https://bongloy.com/documentation#bongloy_api_reference) is described in detail with example CURL requests.

### Authentication

The environment variable `BONGLOY_SECRET_KEY` can be set to automatically configure Bongloy with your [API Key](https://bongloy.com/documentation/#bongloy_api_reference_authentication). For example:

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

token = Bongloy::ApiResource::Token.new
token.api_key
# => "sk_test_my_secret_api_key"
```

Alternatively you can set your [API Key](https://bongloy.com/documentation/#bongloy_api_reference_authentication) each time when you create an API Resource. For example:

```
$ bundle exec irb
```

```ruby
require 'bongloy'

token = Bongloy::ApiResource::Token.new
token.api_key
# => nil
token.api_key = "sk_test_my_secret_api_key"
# => "sk_test_my_secret_api_key"
```

The following examples should actually work if you provide the correct credentials. Replace `sk_test_my_secret_api_key` with your own [Secret API Key](https://bongloy.com/documentation/#bongloy_api_reference_authentication).

### Charges

See also [Bongloy API -> Charges](https://bongloy.com/documentation#bongloy_api_reference_charges)

#### Creating a Charge (charging a credit or Wing card)

See also [Bongloy API -> Charges -> Create a new charge](https://bongloy.com/documentation#bongloy_api_reference_charges_create_charge)

##### Valid Request, $5 USD charge, supplying a Card with no Customer

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

charge = Bongloy::ApiResource::Charge.new
charge.amount = "500"                              # amount in cents
charge.currency = "usd"
charge.source = "unused_token_representing_a_card" # obtained from Bongloy Checkout or Tokens API

begin
  charge.save!
rescue Bongloy::Error::Api::BaseError => e
end
# => true

charge.id
# => "19b1910f-1a2c-4109-82e2-536f230ee126"

charge.livemode?
# => false

charge.captured?
# => true

charge.amount
# => 500

charge.currency
# => "USD"
```

##### Valid Request, 10,000 KHR charge, supplying a Customer with no Card

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

charge = Bongloy::ApiResource::Charge.new
charge.amount = "10000"            # amount in Riel
charge.currency = "khr"
charge.customer = "id_of_customer" # See Customers API

begin
  charge.save!
rescue Bongloy::Error::Api::BaseError => e
end
# => true

charge.id
# => "5d2dd464-1f49-4c32-b9ba-122a01ed9c13"

charge.livemode?
# => false

charge.captured?
# => true

charge.amount
# => 10000

charge.currency
# => "KHR"
```

##### Invalid Request, Insufficient Funds

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

charge = Bongloy::ApiResource::Charge.new
charge.amount = "100000"
charge.currency = "khr"
charge.customer = "id_of_customer" # See Customers API

begin
  charge.save!
rescue Bongloy::Error::Api::BaseError => e
end

e.code
# => 422

e.to_hash
# => {"error"=>{"card_object"=>[". ERROR: Not enough wallet balance to do transactions."], "message"=>["Card object . ERROR: Not enough wallet balance to do transactions."], "param"=>["card_object"]}, "code"=>422}

e.to_json
# => "{\"error\":{\"card_object\":[\". ERROR: Not enough wallet balance to do transactions.\"],\"message\":[\"Card object . ERROR: Not enough wallet balance to do transactions.\"],\"param\":[\"card_object\"]},\"code\":422}"

e.message
# => "422. card_object . ERROR: Not enough wallet balance to do transactions., message Card object . ERROR: Not enough wallet balance to do transactions., param card_object"
```

#### Retrieve an existing Charge

See also [Bongloy API -> Charges -> Retrieve an existing charge](https://bongloy.com/documentation#bongloy_api_reference_charges_retrieve_charge)

##### Valid Request

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

charge = Bongloy::ApiResource::Charge.new
charge.id = "a37d15fb-8f8e-43ea-ba84-9269bbac1560" # Obtained by creating a Charge

begin
  charge.retrieve!
rescue Bongloy::Error::Api::BaseError => e
end

charge.id
# => "a37d15fb-8f8e-43ea-ba84-9269bbac1560"

charge.amount
# => 500

charge.currency
# => "USD"

charge.livemode?
# => false

charge.captured?
# => true

charge.customer
# => nil

charge.source
# => {"id"=>"27d84373-c365-417c-8117-e9efc2eefd6c", "exp_month"=>12, "exp_year"=>2020, "name"=>nil, "address_line1"=>nil, "address_line2"=>nil, "address_city"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_country"=>nil, "brand"=>"visa", "fingerprint"=>nil, "country"=>nil, "cvc_check"=>nil, "address_line1_check"=>nil, "address_zip_check"=>nil, "object"=>"card", "last4"=>"4242", "created"=>1444296033, "customer"=>nil}
```

##### Invalid Request, Charge not found

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

charge = Bongloy::ApiResource::Charge.new
charge.id = "invalid_charge_id"

begin
  charge.retrieve!
rescue Bongloy::Error::Api::BaseError => e
end

e.code
# => 404

e.to_hash
# => {"errors"=>{"base"=>["No such resource: https://bongloy.com/api/v1/charges/invalid_charge_id"]}, "code"=>404, "resource"=>"https://bongloy.com/api/v1/charges/ch_invalid_charge_id"}

e.to_json
# => "{\"errors\":{\"base\":[\"No such resource: https://bongloy.com/api/v1/charges/invalid_charge_id\"]},\"code\":404,\"resource\":\"https://bongloy.com/api/v1/charges/ch_invalid_charge_id\"}"

e.message
# => "404. No such resource: https://bongloy.com/api/v1/charges/invalid_charge_id"
```

### Customers

See also [Bongloy API -> Customers](https://bongloy.com/documentation#bongloy_api_reference_customers)

#### Create a Customer

See also [Bongloy API -> Customers -> Create a new customer](https://bongloy.com/documentation#bongloy_api_reference_customers_create_customer)

##### Valid request, Supplying a Card, Email and Description

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

customer = Bongloy::ApiResource::Customer.new
customer.source = "unused_token_representing_a_card" # obtained from Bongloy Checkout or Tokens API
customer.email = "someone@example.com"
customer.description = "My first customer"

begin
  customer.save!
rescue Bongloy::Error::Api::BaseError => e
end
# => true

customer.id
# => "1e7cc759-fdc3-4207-8080-6ceff36e1bcb"

customer.email
# => "someone@example.com"

customer.description
# => "My first customer"

customer.livemode?
# => false

customer.default_source
# => {"id"=>"5484df08-de2a-4064-b9a2-a5dce069571e", "exp_month"=>10, "exp_year"=>2015, "name"=>nil, "address_line1"=>nil, "address_line2"=>nil, "address_city"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_country"=>nil, "brand"=>"visa", "fingerprint"=>nil, "country"=>nil, "cvc_check"=>nil, "address_line1_check"=>nil, "address_zip_check"=>nil, "object"=>"card", "last4"=>"4242", "created"=>1444297096, "customer"=>"1e7cc759-fdc3-4207-8080-6ceff36e1bcb"}
```

##### Invalid Request, Token already used

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

customer = Bongloy::ApiResource::Customer.new
customer.source = "tok_63a8609a36ee3430c8a57fa877a8bfa973c37360f24553d8c66d71ae5116931e"

begin
  customer.save!
rescue Bongloy::Error::Api::BaseError => e
end

e.code
# => 422

e.to_hash
# => {"error"=>{"default_payment_source"=>["not found"], "message"=>["Default payment source not found"], "param"=>["default_payment_source"]}, "code"=>422}

e.to_json
# => "{\"error\":{\"default_payment_source\":[\"not found\"],\"message\":[\"Default payment source not found\"],\"param\":[\"default_payment_source\"]},\"code\":422}"

e.message
# => "422. default_payment_source not found, message Default payment source not found, param default_payment_source"
```

#### Retrieve an existing Customer

See also [Bongloy API -> Customers -> Retrieve an existing customer](https://bongloy.com/documentation#bongloy_api_reference_customers_retrieve_customer)

##### Valid Request

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

customer = Bongloy::ApiResource::Customer.new
customer.id = "cada493f-61c1-413b-8064-c1b7abec93fa" # Obtained by creating a Customer

begin
  customer.retrieve!
rescue Bongloy::Error::Api::BaseError => e
end

customer.id
# => "cada493f-61c1-413b-8064-c1b7abec93fa"

customer.email
# => "someone@example.com"

customer.description
# => "My first customer"

customer.default_source
# => {"id"=>"2b575213-f87f-462b-89db-0d6ce8dce338", "exp_month"=>12, "exp_year"=>2020, "name"=>nil, "address_line1"=>nil, "address_line2"=>nil, "address_city"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_country"=>nil, "brand"=>"wing", "fingerprint"=>nil, "country"=>nil, "object"=>"card", "last4"=>"62", "created"=>1444296198, "customer"=>"cada493f-61c1-413b-8064-c1b7abec93fa"}
```

##### Invalid Request, Customer not found

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

customer = Bongloy::ApiResource::Customer.new
customer.id = "invalid_customer_id"

begin
  customer.retrieve!
rescue Bongloy::Error::Api::BaseError => e
end

e.code
# => 404

e.to_hash
# => {"errors"=>{"base"=>["No such resource: https://bongloy.com/api/v1/customers/invalid_customer_id"]}, "code"=>404, "resource"=>"https://bongloy.com/api/v1/customers/invalid_customer_id"}

e.to_json
# => "{\"errors\":{\"base\":[\"No such resource: https://bongloy.com/api/v1/customers/invalid_customer_id\"]},\"code\":404,\"resource\":\"https://bongloy.com/api/v1/customers/invalid_customer_id\"}"

e.message
# => "404. No such resource: https://bongloy.com/api/v1/customers/invalid_customer_id"
```

#### Update an existing Customer

See also [Bongloy API -> Customers -> Update an existing Customer](https://bongloy.com/documentation#bongloy_api_reference_customers_update_customer)

##### Valid Request, Updating the Card, Email and Description

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

customer = Bongloy::ApiResource::Customer.new
customer.id = "cada493f-61c1-413b-8064-c1b7abec93fa"
customer.source = "unused_token_representing_a_card" # obtained from Bongloy Checkout or Tokens API
customer.email = "updated_customer@example.com"
customer.description = "my updated first customer"

begin
  customer.save!
  customer.retrieve!
rescue Bongloy::Error::Api::BaseError => e
end

customer.id
# => "cada493f-61c1-413b-8064-c1b7abec93fa"

customer.email
# => "updated_customer@example.com"

customer.description
# => "my updated first customer"

customer.default_source
# => {"id"=>"2b575213-f87f-462b-89db-0d6ce8dce338", "exp_month"=>12, "exp_year"=>2020, "name"=>nil, "address_line1"=>nil, "address_line2"=>nil, "address_city"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_country"=>nil, "brand"=>"wing", "fingerprint"=>nil, "country"=>nil, "object"=>"card", "last4"=>"62", "created"=>1444296198, "customer"=>"cada493f-61c1-413b-8064-c1b7abec93fa"}
```

##### Invalid Request, Customer not found

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

customer = Bongloy::ApiResource::Customer.new
customer.id = "invalid_customer_id"
customer.source = "tok_unused_token_representing_a_card" # obtained from Bongloy Checkout or Tokens API
customer.email = "updated_customer@example.com"
customer.description = "my updated first customer"

begin
  customer.save!
  customer.retrieve!
rescue Bongloy::Error::Api::BaseError => e
end

e.code
# => 404

e.to_hash
# => {"errors"=>{"base"=>["No such resource: https://bongloy.com/api/v1/customers/invalid_customer_id"]}, "code"=>404, "resource"=>"https://bongloy.com/api/v1/customers/invalid_customer_id"}

e.to_json
# => "{\"errors\":{\"base\":[\"No such resource: https://bongloy.com/api/v1/customers/invalid_customer_id\"]},\"code\":404,\"resource\":\"https://bongloy.com/api/v1/customers/invalid_customer_id\"}"

e.message
# => "404. No such resource: https://bongloy.com/api/v1/customers/invalid_customer_id"
```

### Cards

See also [Bongloy API -> Cards](https://bongloy.com/documentation#bongloy_api_reference_cards)

#### Create a Card (Attach a new Card to a Customer)

See also [Bongloy API -> Cards -> Create a new card](https://bongloy.com/documentation#bongloy_api_reference_cards_create_card)

##### Valid Request

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

card = Bongloy::ApiResource::Card.new("existing_customer_id") # Obtained by creating a customer
card.source = "unused_token_representing_a_card" # obtained from Bongloy Checkout or Tokens API

begin
  card.save!
rescue Bongloy::Error::Api::BaseError => e
end

card.id
# => "5a6843ac-1737-4039-aff2-7f56610752b2"

card.livemode?
# => false

card.exp_month
# => 10

card.exp_year
# => 2015

card.brand
# => "visa"

card.last4
# => "4242"
```

##### Invalid Request (Token already used)

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

card = Bongloy::ApiResource::Card.new("existing_customer_id") # Obtained by creating a customer
card.source = "used_token" # obtained from Bongloy Checkout or Tokens API

begin
  card.save!
rescue Bongloy::Error::Api::BaseError => e
end

e.code
# => 422

e.to_hash
# => {"error"=>{"token"=>["not found"], "message"=>["Token not found"], "param"=>["token"]}, "code"=>422}

e.to_json
# => "{\"error\":{\"token\":[\"not found\"],\"message\":[\"Token not found\"],\"param\":[\"token\"]},\"code\":422}"

e.message
# => "422. token not found, message Token not found, param token"
```

#### Retrieve a Card

See also [Bongloy API -> Cards -> Create an existing card](https://bongloy.com/documentation#bongloy_api_reference_cards_retrieve_card)

##### Valid Request

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

card = Bongloy::ApiResource::Card.new("existing_customer_id") # obtained by creating a Customer
card.id = "existing_card_id"                                  # obtained by creating a Card

begin
  card.retrieve!
rescue Bongloy::Error::Api::BaseError => e
end

card.id
# => "5a6843ac-1737-4039-aff2-7f56610752b2"

card.livemode?
# => false

card.exp_month
# => 10

card.exp_year
# => 2015

card.brand
# => "visa"

card.last4
# => "4242"

card.name
# => nil
```

##### Invalid Request (Card not found)

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

card = Bongloy::ApiResource::Card.new("existing_customer_id") # obtained by creating a customer
card.id = "incorrect_card_id"

begin
  card.retrieve!
rescue Bongloy::Error::Api::BaseError => e
end

e.code
# => 404

e.to_hash
# => {"errors"=>{"base"=>["No such resource: https://bongloy.com/api/v1/customers/existing_customer_id/payment_sources/incorrect_card_id"]}, "code"=>404, "resource"=>"https://bongloy.com/api/v1/customers/existing_customer_id/payment_sources/incorrect_card_id"}

e.to_json
# => "{\"errors\":{\"base\":[\"No such resource: https://bongloy.com/api/v1/customers/existing_customer_id/payment_sources/incorrect_card_id\"]},\"code\":404,\"resource\":\"https://bongloy.com/api/v1/customers/existing_customer_id/payment_sources/incorrect_card_id\"}"

e.message
# => "404. No such resource: https://bongloy.com/api/v1/customers/existing_customer_id/payment_sources/incorrect_card_id"
```

#### Update a Card

See also [Bongloy API -> Cards -> Update an existing card](https://bongloy.com/documentation#bongloy_api_reference_cards_update_card)

##### Valid Request

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

card = Bongloy::ApiResource::Card.new("existing_customer_id") # obtained by creating a Customer
card.id = "existing_card_id"                                  # obtained by creating a Card
card.name = "Laura Mom"

begin
  card.save!
  card.retrieve!
rescue Bongloy::Error::Api::BaseError => e
end

card.id
# => "5a6843ac-1737-4039-aff2-7f56610752b2"

card.name
# => "Laura Mom"
```

### Tokens

See also [Bongloy API -> Tokens](https://bongloy.com/documentation#bongloy_api_reference_tokens)

#### Create a Token

See also [Bongloy API -> Tokens -> Create a new token](https://bongloy.com/documentation#bongloy_api_reference_tokens_create_token)

##### Valid request, Create a Credit Card Token

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

token = Bongloy::ApiResource::Token.new
token.card = {:number => "4242424242424242", :exp_month => "12", :exp_year => "2020", :cvc => "123"}

begin
  token.save!
rescue Bongloy::Error::Api::BaseError => e
end

token.id
# => "93ed61a0-cc53-49f0-a304-5bef8313ee39"

token.livemode?
# => false

token.used?
# => false

token.card
# => {"id"=>"27d84373-c365-417c-8117-e9efc2eefd6c", "exp_month"=>12, "exp_year"=>2020, "name"=>nil, "address_line1"=>nil, "address_line2"=>nil, "address_city"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_country"=>nil, "brand"=>"visa", "fingerprint"=>nil, "country"=>nil, "cvc_check"=>nil, "address_line1_check"=>nil, "address_zip_check"=>nil, "object"=>"card", "last4"=>"4242", "created"=>1444296033, "customer"=>nil}
```

##### Valid request, Create a Wing Card Token

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

token = Bongloy::ApiResource::Token.new
token.card = {:number => "5018188000383662", :exp_month => "12", :exp_year => "2020", :cvc => "2008"}

begin
  token.save!
rescue Bongloy::Error::Api::BaseError => e
end

token.id
# => "74596e5e-7350-48f1-a079-6be548b425b9"

token.livemode?
# => false

token.used?
# => false

token.card
# => {"id"=>"2b575213-f87f-462b-89db-0d6ce8dce338", "exp_month"=>12, "exp_year"=>2020, "name"=>nil, "address_line1"=>nil, "address_line2"=>nil, "address_city"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_country"=>nil, "brand"=>"wing", "fingerprint"=>nil, "country"=>nil, "object"=>"card", "last4"=>"62", "created"=>1444296198, "customer"=>nil}
```

##### Invalid request, PIN (CVC) not supplied

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

token = Bongloy::ApiResource::Token.new
token.card = {:number => "5018188000383662", :exp_month => "12", :exp_year => "2020"}

begin
  token.save!
rescue Bongloy::Error::Api::BaseError => e
end

e.code
# => 422

e.to_hash
# => {"error"=>{"card"=>["is invalid"], "message"=>["Card is invalid"], "param"=>["card"]}, "code"=>422}

e.to_json
# => "{\"error\":{\"card\":[\"is invalid\"],\"message\":[\"Card is invalid\"],\"param\":[\"card\"]},\"code\":422}"

e.message
# => "422. card is invalid, message Card is invalid, param card"
```

#### Retrieve an existing Token

See also [Bongloy API -> Tokens -> Retrieve an existing token](https://bongloy.com/documentation#bongloy_api_reference_tokens_retrieve_token)

##### Valid Request

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

token = Bongloy::ApiResource::Token.new
token.id = "74596e5e-7350-48f1-a079-6be548b425b9" # Obtained by Bongloy Checkout or the Tokens API

begin
  token.retrieve!
rescue Bongloy::Error::Api::BaseError => e
end

token.id
# => "74596e5e-7350-48f1-a079-6be548b425b9"

token.livemode?
# => false

token.used?
# => false

token.card
# => {"id"=>"2b575213-f87f-462b-89db-0d6ce8dce338", "exp_month"=>12, "exp_year"=>2020, "name"=>nil, "address_line1"=>nil, "address_line2"=>nil, "address_city"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_country"=>nil, "brand"=>"wing", "fingerprint"=>nil, "country"=>nil, "object"=>"card", "last4"=>"62", "created"=>1444296198, "customer"=>nil}
```

##### Invalid Request, Token not found

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

token = Bongloy::ApiResource::Token.new
token.id = "invalid_token_id"

begin
  token.retrieve!
rescue Bongloy::Error::Api::BaseError => e
end

e.code
# => 404

e.to_hash
# => {"errors"=>{"base"=>["No such resource: https://bongloy.com/api/v1/tokens/invalid_token_id"]}, "code"=>404, "resource"=>"https://bongloy.com/api/v1/tokens/invalid_token_id"}

e.to_json
# => "{\"errors\":{\"base\":[\"No such resource: https://bongloy.com/api/v1/tokens/invalid_token_id\"]},\"code\":404,\"resource\":\"https://bongloy.com/api/v1/tokens/invalid_token_id\"}"

e.message
# => "404. No such resource: https://bongloy.com/api/v1/tokens/invalid_token_id"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
