require 'spec_helper'

describe Bongloy::ApiResource::Charge do
  include Bongloy::SpecHelpers::ApiRequestExamples

  let(:api_request_helpers) { Bongloy::SpecHelpers::ApiRequestHelpers.new }
  let(:api_resource_endpoint) { :charges }

  subject { build(:charge) }

  it_should_behave_like "a bongloy api resource"

  describe "#card=(token)" do
    it "should set the card parameter" do
      subject.card = "token"
      subject.params[:card].should == "token"
    end
  end
end
