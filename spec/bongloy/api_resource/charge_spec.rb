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

  describe "#amount=(value)" do
    it "should set amount parameter" do
      subject.amount = 1000
      subject.params[:amount].should == 1000
    end
  end

  describe "#currency=(value)" do
    it "should set the currency parameter" do
      subject.currency = "khr"
      subject.params[:currency].should == "khr"
    end
  end

  describe "#retrieve!(query_params = {}, headers = {})" do
    subject { build(:charge, :with_id, :id => "ch_replace_me_with_actual_charge_id") }

    it "should try to find the resource by the given id" do
      expect_api_request(:ok, :api_resource_id => subject.id) do
        subject.retrieve!
        subject.object.should == "charge"
      end
    end
  end
end
