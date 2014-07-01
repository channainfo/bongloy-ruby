# Bongloy

Consumes the [Bongloy API](http://bongloy.com)

## Installation

Add this line to your application's Gemfile:

    gem 'bongloy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bongloy

## Configuration

The environment variable `BONGLOY_SECRET_KEY` can be set to automatically configure Bongloy with your API Key. For example:

```
$ BONGLOY_SECRET_KEY="sk_test_236103e5d6e3b35c613ef292e8b806a4997bdeece64813229d3d6cf7e50ce2a1" irb
```

```ruby
require 'bongloy'

token = Bongloy::ApiResource::Token.new
token.api_key
=> "sk_test_236103e5d6e3b35c613ef292e8b806a4997bdeece64813229d3d6cf7e50ce2a1"
```

Alternatively you can set your API Key each time when you create an API Resource. For example:

```
$ irb
```

```ruby
require 'bongloy'

token = Bongloy::ApiResource::Token.new
token.api_key
=> nil
token.api_key = "sk_test_236103e5d6e3b35c613ef292e8b806a4997bdeece64813229d3d6cf7e50ce2a1"
=> "sk_test_236103e5d6e3b35c613ef292e8b806a4997bdeece64813229d3d6cf7e50ce2a1"
token.api_key
=> "sk_test_236103e5d6e3b35c613ef292e8b806a4997bdeece64813229d3d6cf7e50ce2a1"
```

## Usage

## Tokens

Tokens are Bongloy's representation of a Card. Normally you would use Bongloy Checkout to create tokens and then use them on the server side to create Charges or Customers. Tokens can also be created directly as shown below.

### Create a Credit Card Token

After creating a Credit Card token, you can use it to charge the Credit Card immediatley or create a Customer who's Credit Card you can charge later.

```
$ irb
```

```ruby
require 'bongloy'

token = Bongloy::ApiResource::Token.new
token.api_key = "<your_api_key>"
token.card = {:number=>"4242424242424242", :exp_month=>12, :exp_year=>2015}
token.save!
token.id
=> "tok_50415d300fd45f72475abc75392708dedcd7500c7a98a7a62e34411f4c8a6640"
```

### Create a Wing Card Token

After creating a Wing Card token, you can use it to charge the Wing Card immediately or create a Customer who's Wing card you can charge later.

```
$ BONGLOY_SECRET_KEY="sk_test_236103e5d6e3b35c613ef292e8b806a4997bdeece64813229d3d6cf7e50ce2a1" irb
```

```ruby
require 'bongloy'

token = Bongloy::ApiResource::Token.new
token.card = {:account_number=>"1614", :pin=>1234}
token.save!
token.id
=> "tok_3e00cd6399e6129574550f5cab42adf40463dd2f40dde67eff3c9330d8840a2a"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
