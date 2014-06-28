require 'spec_helper'

describe Bongloy::ApiResource::Charge do
  include Bongloy::SpecHelpers::ApiRequestExamples

  let(:api_request_helpers) { Bongloy::SpecHelpers::ApiRequestHelpers.new }
  let(:api_resource_endpoint) { :charges }

  subject { build(:charge) }

  it_should_behave_like "a bongloy api resource"
end
