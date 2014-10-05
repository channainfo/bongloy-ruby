require 'spec_helper'

describe Bongloy::ApiResource::Charge do
  include Bongloy::SpecHelpers::ApiRequestExamples

  let(:api_request_helpers) { Bongloy::SpecHelpers::ApiRequestHelpers.new }
  let(:api_resource_endpoint) { :charges }
  let(:asserted_retrieved_object) { "charge" }
  let(:factory) { :charge }
  subject { build(factory) }

  it_should_behave_like "a bongloy api resource"

  describe "#card=(token_id)" do
    it "should set the card parameter" do
      subject.card = "tok_my_token"
      subject.params[:card].should == "tok_my_token"
    end
  end

  describe "#customer=(customer_id)" do
    it "should set the customer parameter" do
      subject.customer = "cus_my_customer_id"
      subject.params[:customer].should == "cus_my_customer_id"
    end
  end

  describe "#capture=(value)" do
    it "should set the capture" do
      subject.capture = false
      subject.params[:capture].should == false
    end
  end

  describe "#description=(value)" do
    it "should set the description" do
      subject.description = "some description"
      subject.params[:description].should == "some description"
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

  describe "#save!(headers = {})" do
    context "for an existing charge" do
      subject { build(factory, :with_id) }
      it_should_behave_like "a non updatable api resource"
    end
  end
end
