$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'bongloy'

RSpec.configure do |config|
  Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}
end
