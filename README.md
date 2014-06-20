# Bongloy

Consumes the [Bongloy API](http://bongloy.com)

## Installation

Add this line to your application's Gemfile:

    gem 'bongloy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bongloy

## Usage

## Tokens

### Create a Token

```ruby
require 'bongloy'

token = Bongloy::ApiResource::Token.new
token.api_key = "<your_api_key>"
token.card = {:number=>"4242424242424242", :exp_month=>12, :exp_year=>2015}
token.save!
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
