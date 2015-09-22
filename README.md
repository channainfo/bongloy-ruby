# Bongloy

[![Build Status](https://travis-ci.org/dwilkie/bongloy-ruby.svg?branch=master)](https://travis-ci.org/dwilkie/bongloy-ruby)

Consumes the [Bongloy API](https://bongloy.com/documentation#bongloy_api_reference)

## Installation

This gem is still in beta. To install:

Add this line to your application's Gemfile:

    gem 'bongloy', :github => "dwilkie/bongloy-ruby"

And then execute:

    $ bundle

## Usage

### Full API Documentation

The [Bongloy API](https://bongloy.com/documentation#bongloy_api_reference) is described in detail with example CURL requests.

### Authentication

The environment variable `BONGLOY_SECRET_KEY` can be set to automatically configure Bongloy with your Secret API Key. For example:

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

token = Bongloy::ApiResource::Token.new
token.api_key
# => "sk_test_my_secret_api_key"
```

Alternatively you can set your API Key each time when you create an API Resource. For example:

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
charge.amount = "500"
charge.currency = "usd"
charge.source = "tok_unused_token_representing_a_card" # obtained from Bongloy Checkout or Tokens API

begin
  charge.save!
rescue Bongloy::Error::Api::BaseError => e
end
# => true

charge.id
# => "ch_07966e4f83601742ad00635de6a660957651b2b54da2f0bc619e6389c446cf7f"

charge.livemode?
# => false

charge.captured?
# => true
```

##### Valid Request, 10,000 KHR charge, supplying a Customer with no Card

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

charge = Bongloy::ApiResource::Charge.new
charge.amount = "10000"
charge.currency = "khr"
charge.customer = "cus_id_of_customer" # See Customers API

begin
  charge.save!
rescue Bongloy::Error::Api::BaseError => e
end
# => true

charge.livemode?
# => false

charge.id
# => "ch_c10e4015bc3c4668f56ef6b3f8fb520f3287638617872ee80ed9227cd58bbdfb"

charge.captured?
# => true
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
charge.customer = "cus_id_of_customer" # See Customers API

begin
  charge.save!
rescue Bongloy::Error::Api::BaseError => e
  error_code = e.code
  error_hash = e.to_hash
  error_json = e.to_json
  error_message = e.message
end

error_code
# => 422

error_hash
# => {"error"=>{"card_object"=>[". ERROR: Not enough wallet balance to do transactions."], "message"=>["Card object . ERROR: Not enough wallet balance to do transactions."], "param"=>["card_object"]}, "code"=>422}

error_json
# => "{\"error\":{\"card_object\":[\". ERROR: Not enough wallet balance to do transactions.\"],\"message\":[\"Card object . ERROR: Not enough wallet balance to do transactions.\"],\"param\":[\"card_object\"]},\"code\":422}"

error_message
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
charge.id = "ch_c10e4015bc3c4668f56ef6b3f8fb520f3287638617872ee80ed9227cd58bbdfb" # Obtained by creating a Charge

begin
  charge.retrieve!
rescue Bongloy::Error::Api::BaseError => e
end

charge.id
# => "ch_c10e4015bc3c4668f56ef6b3f8fb520f3287638617872ee80ed9227cd58bbdfb"

charge.amount
# => 10000

charge.currency
# => "khr"

charge.livemode?
# => false

charge.captured?
# => true

charge.customer
# => "cus_ff7ddd764812d90c0fbab58bd38a4bfd991fb8ffeb21ce93d6a7753bbfd4e668"

charge.source
# => {"exp_month"=>12, "exp_year"=>2020, "name"=>nil, "address_line1"=>nil, "address_line2"=>nil, "address_city"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_country"=>nil, "fingerprint"=>nil, "country"=>nil, "object"=>"card", "last4"=>"63", "id"=>"card_11a142856c7e8cdcad802f2f11ba479c1f3f49f8b4da8ceb1e3ca60dc4a6a3e5", "created"=>1412392253, "customer"=>"cus_ff7ddd764812d90c0fbab58bd38a4bfd991fb8ffeb21ce93d6a7753bbfd4e668", "brand"=>"wing"}
```

##### Invalid Request, Charge not found

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

charge = Bongloy::ApiResource::Charge.new
charge.id = "ch_invalid_charge_id"

begin
  charge.retrieve!
rescue Bongloy::Error::Api::BaseError => e
  error_code = e.code
  error_hash = e.to_hash
  error_json = e.to_json
  error_message = e.message
end

error_code
# => 404

error_hash
# => {"errors"=>{"base"=>["No such resource: https://bongloy.com/api/v1/charges/ch_invalid_charge_id"]}, "code"=>404, "resource"=>"https://bongloy.com/api/v1/charges/ch_invalid_charge_id"}

error_json
# => "{\"errors\":{\"base\":[\"No such resource: https://bongloy.com/api/v1/charges/ch_invalid_charge_id\"]},\"code\":404,\"resource\":\"https://bongloy.com/api/v1/charges/ch_invalid_charge_id\"}"

error_message
# => "404. No such resource: https://bongloy.com/api/v1/charges/ch_invalid_charge_id"
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
customer.source = "tok_unused_token_representing_a_card" # obtained from Bongloy Checkout or Tokens API
customer.email = "someone@example.com"
customer.description = "My first customer"

begin
  customer.save!
rescue Bongloy::Error::Api::BaseError => e
end
# => true

customer.id
# => "cus_602f930f506730ce4edc943f2b6d9580df3499d138e397caea7f6f2febe1fb86"

customer.email
# => "someone@example.com"

customer.description
# => "My first customer"

customer.livemode?
# => false

customer.default_source
# => {"exp_month"=>12, "exp_year"=>2020, "name"=>nil, "address_line1"=>nil, "address_line2"=>nil, "address_city"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_country"=>nil, "fingerprint"=>nil, "country"=>nil, "object"=>"card", "last4"=>"62", "id"=>"card_3baeec379b91fb29aa51fcbcebd0ef7bd33697e7922ad13e70b18125512863c8", "created"=>1412488139, "customer"=>"cus_602f930f506730ce4edc943f2b6d9580df3499d138e397caea7f6f2febe1fb86", "brand"=>"wing"}
```

##### Invalid Request, Token already used

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

customer = Bongloy::ApiResource::Customer.new
customer.card = "tok_63a8609a36ee3430c8a57fa877a8bfa973c37360f24553d8c66d71ae5116931e"

begin
  customer.save!
rescue Bongloy::Error::Api::BaseError => e
  error_code = e.code
  error_hash = e.to_hash
  error_json = e.to_json
  error_message = e.message
end

error_code
# => 422

error_hash
# => {"error"=>{"default_source"=>["can't be blank"], "message"=>["Default card can't be blank"], "param"=>["default_source"]}, "code"=>422}

error_json
# => "{\"error\":{\"default_source\":[\"can't be blank\"],\"message\":[\"Default card can't be blank\"],\"param\":[\"default_source\"]},\"code\":422}"

error_message
# => "422. default_source can't be blank, message Default card can't be blank, param default_source"
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
customer.id = "cus_602f930f506730ce4edc943f2b6d9580df3499d138e397caea7f6f2febe1fb86" # Obtained by creating a Customer

begin
  customer.retrieve!
rescue Bongloy::Error::Api::BaseError => e
end

customer.id
# => "cus_602f930f506730ce4edc943f2b6d9580df3499d138e397caea7f6f2febe1fb86"

customer.email
# => "someone@example.com"

customer.description
# => "My first customer"

customer.default_source
# => {"exp_month"=>12, "exp_year"=>2020, "name"=>nil, "address_line1"=>nil, "address_line2"=>nil, "address_city"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_country"=>nil, "fingerprint"=>nil, "country"=>nil, "object"=>"card", "last4"=>"62", "id"=>"card_3baeec379b91fb29aa51fcbcebd0ef7bd33697e7922ad13e70b18125512863c8", "created"=>1412488139, "customer"=>"cus_602f930f506730ce4edc943f2b6d9580df3499d138e397caea7f6f2febe1fb86", "brand"=>"wing"}
```

##### Invalid Request, Customer not found

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

customer = Bongloy::ApiResource::Customer.new
customer.id = "cus_invalid_customer_id"

begin
  customer.retrieve!
rescue Bongloy::Error::Api::BaseError => e
  error_code = e.code
  error_hash = e.to_hash
  error_json = e.to_json
  error_message = e.message
end

error_code
# => 404

error_hash
# => {"errors"=>{"base"=>["No such resource: https://bongloy.com/api/v1/customers/cus_invalid_customer_id"]}, "code"=>404, "resource"=>"https://bongloy.com/api/v1/customers/cus_invalid_customer_id"}

error_json
# => "{\"errors\":{\"base\":[\"No such resource: https://bongloy.com/api/v1/customers/cus_invalid_customer_id\"]},\"code\":404,\"resource\":\"https://bongloy.com/api/v1/customers/cus_invalid_customer_id\"}"

error_message
# => "404. No such resource: https://bongloy.com/api/v1/customers/cus_invalid_customer_id"
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
customer.id = "cus_602f930f506730ce4edc943f2b6d9580df3499d138e397caea7f6f2febe1fb86"
customer.source = "tok_unused_token_representing_a_card" # obtained from Bongloy Checkout or Tokens API
customer.email = "updated_customer@example.com"
customer.description = "my updated first customer"

begin
  customer.save!
  customer.retrieve!
rescue Bongloy::Error::Api::BaseError => e
end

customer.id
# => "cus_602f930f506730ce4edc943f2b6d9580df3499d138e397caea7f6f2febe1fb86"

customer.email
# => "updated_customer@example.com"

customer.description
# => "my updated first customer"

customer.default_source
# => {"exp_month"=>12, "exp_year"=>2020, "name"=>nil, "address_line1"=>nil, "address_line2"=>nil, "address_city"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_country"=>nil, "fingerprint"=>nil, "country"=>nil, "cvc_check"=>nil, "address_line1_check"=>nil, "address_zip_check"=>nil, "object"=>"card", "last4"=>"4242", "id"=>"card_06bc6faa5159e33aabb93f808a8cf2a5cc8c71bfc48a0a3657623c49c6910cbe", "created"=>1412490560, "customer"=>"cus_602f930f506730ce4edc943f2b6d9580df3499d138e397caea7f6f2febe1fb86", "brand"=>"visa"}
```

##### Invalid Request, Customer not found

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

customer = Bongloy::ApiResource::Customer.new
customer.id = "cus_invalid_customer_id"
customer.source = "tok_unused_token_representing_a_card" # obtained from Bongloy Checkout or Tokens API
customer.email = "updated_customer@example.com"
customer.description = "my updated first customer"

begin
  customer.save!
  customer.retrieve!
rescue Bongloy::Error::Api::BaseError => e
  error_code = e.code
  error_hash = e.to_hash
  error_json = e.to_json
  error_message = e.message
end

error_code
# => 404

error_hash
# => {"errors"=>{"base"=>["No such resource: https://bongloy.com/api/v1/customers/cus_invalid_customer_id"]}, "code"=>404, "resource"=>"https://bongloy.com/api/v1/customers/cus_invalid_customer_id"}

error_json
# => "{\"errors\":{\"base\":[\"No such resource: https://bongloy.com/api/v1/customers/cus_invalid_customer_id\"]},\"code\":404,\"resource\":\"https://bongloy.com/api/v1/customers/cus_invalid_customer_id\"}"

error_message
# => "404. No such resource: https://bongloy.com/api/v1/customers/cus_invalid_customer_id"
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
token.card = {:number => "4242424242424242", :exp_month => "12", :exp_year => "2020"}

begin
  token.save!
rescue Bongloy::Error::Api::BaseError => e
end

token.id
# => "tok_1204c78e50c1c2b7fcd23d56fa63171372d88c8a595714e7b05b371de904be8d"

token.livemode?
# => false

token.used?
# => false

token.card
# => {"exp_month"=>12, "exp_year"=>2020, "name"=>nil, "address_line1"=>nil, "address_line2"=>nil, "address_city"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_country"=>nil, "fingerprint"=>nil, "country"=>nil, "cvc_check"=>nil, "address_line1_check"=>nil, "address_zip_check"=>nil, "object"=>"card", "last4"=>"4242", "id"=>"card_714ffdd6fa9bb74b497cbf954fa80318b268c720176eca811d67431e9428161e", "created"=>1412492468, "customer"=>nil, "brand"=>"visa"}
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
# => "tok_f1a00cdc899bc3c78e906033d17f79cd17bc43f2868580439b89fd127b40aa9f"

token.livemode?
# => false

token.used?
# => false

token.card
# => {"exp_month"=>12, "exp_year"=>2020, "name"=>nil, "address_line1"=>nil, "address_line2"=>nil, "address_city"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_country"=>nil, "fingerprint"=>nil, "country"=>nil, "object"=>"card", "last4"=>"62", "id"=>"card_055836d0a59b092419a9395f26b16c432dd7ae1001854481ec0eedf0f7d3d9d0", "created"=>1412492637, "customer"=>nil, "brand"=>"wing"}
```

##### Invalid request, PIN (CVC) not supplied for a Wing Card

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
  error_code = e.code
  error_hash = e.to_hash
  error_json = e.to_json
  error_message = e.message
end

error_code
# => 422

error_hash
# => {"error"=>{"card"=>["is invalid"], "message"=>["Card is invalid"], "param"=>["card"]}, "code"=>422}

error_json
# => "{\"error\":{\"card\":[\"is invalid\"],\"message\":[\"Card is invalid\"],\"param\":[\"card\"]},\"code\":422}"

error_message
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
token.id = "tok_1204c78e50c1c2b7fcd23d56fa63171372d88c8a595714e7b05b371de904be8d" # Obtained by Bongloy Checkout or the Tokens API

begin
  token.retrieve!
rescue Bongloy::Error::Api::BaseError => e
end

token.id
# => "tok_1204c78e50c1c2b7fcd23d56fa63171372d88c8a595714e7b05b371de904be8d"

token.livemode?
# => false

token.used?
# => false

token.card
# => {"exp_month"=>12, "exp_year"=>2020, "name"=>nil, "address_line1"=>nil, "address_line2"=>nil, "address_city"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_country"=>nil, "fingerprint"=>nil, "country"=>nil, "cvc_check"=>nil, "address_line1_check"=>nil, "address_zip_check"=>nil, "object"=>"card", "last4"=>"4242", "id"=>"card_714ffdd6fa9bb74b497cbf954fa80318b268c720176eca811d67431e9428161e", "created"=>1412492468, "customer"=>nil, "brand"=>"visa"}
```

##### Invalid Request, Token not found

```
$ BONGLOY_SECRET_KEY="sk_test_my_secret_api_key" bundle exec irb
```

```ruby
require 'bongloy'

token = Bongloy::ApiResource::Token.new
token.id = "tok_invalid_token_id"

begin
  token.retrieve!
rescue Bongloy::Error::Api::BaseError => e
  error_code = e.code
  error_hash = e.to_hash
  error_json = e.to_json
  error_message = e.message
end

error_code
# => 404

error_hash
# => {"errors"=>{"base"=>["No such resource: https://bongloy.com/api/v1/tokens/tok_invalid_token_id"]}, "code"=>404, "resource"=>"https://bongloy.com/api/v1/tokens/tok_invalid_token_id"}

error_json
# => "{\"errors\":{\"base\":[\"No such resource: https://bongloy.com/api/v1/tokens/tok_invalid_token_id\"]},\"code\":404,\"resource\":\"https://bongloy.com/api/v1/tokens/tok_invalid_token_id\"}"

error_message
# => "404. No such resource: https://bongloy.com/api/v1/tokens/tok_invalid_token_id"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
