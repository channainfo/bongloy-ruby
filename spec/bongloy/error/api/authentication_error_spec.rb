require 'spec_helper'

describe Bongloy::Error::Api::AuthenticationError do
  let(:factory_name) { :authentication_error }
  subject { build(factory_name) }
  it_should_behave_like "an api error"

  describe "#message" do
    it "should have a default message" do
      subject.message.should =~ /No valid API key provided./
    end
  end
end
