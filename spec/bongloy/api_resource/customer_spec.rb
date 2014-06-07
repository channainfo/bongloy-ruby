require 'spec_helper'

module Bongloy
  module ApiResource
    describe Customer do
      include Bongloy::SpecHelpers::ApiRequestExamples

      let(:api_request_helpers) { Bongloy::SpecHelpers::ApiRequestHelpers.new }
      let(:api_resource_endpoint) { :customers }

      subject { build(:customer) }

      it_should_behave_like "a bongloy api resource"
    end
  end
end
