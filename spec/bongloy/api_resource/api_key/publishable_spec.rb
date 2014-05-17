require 'spec_helper'

module Bongloy
  module ApiResource
    module ApiKey
      describe Publishable do
        let(:api_key) { "pk_test_abcdefghijklmnopqrstuvwxyz" }
        subject { described_class.new(api_key) }

        describe "#valid?" do
          it "should do something" do
            subject.valid?
          end
        end
      end
    end
  end
end
