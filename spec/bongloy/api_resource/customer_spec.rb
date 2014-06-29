require 'spec_helper'

describe Bongloy::ApiResource::Customer do
  include Bongloy::SpecHelpers::ApiRequestExamples

  let(:api_request_helpers) { Bongloy::SpecHelpers::ApiRequestHelpers.new }
  let(:api_resource_endpoint) { :customers }

  subject { build(:customer) }

  it_should_behave_like "a bongloy api resource"

  describe "#card=(token)" do
    it "should set the card parameter" do
      subject.card = "token"
      subject.params[:card].should == "token"
    end
  end

  describe "#save!(headers = {})" do
    let(:request_body) { WebMock::Util::QueryMapper.query_to_values(WebMock.requests.last.body) }

    context "for a new customer" do
      context "when the customer has no card" do
        before do
          expect_api_request(:created) do
            subject.save!
          end
        end

        it "should not have a default card" do
          subject.default_card.should be_nil
        end
      end

      context "when the customer has a card which is" do
        subject { build(:customer, :with_card) }

        context "valid" do
          before do
            expect_api_request(:created_with_card) do
              subject.save!
            end
          end

          it "should have a default card" do
            subject.default_card.should_not be_nil
          end
        end

        context "invalid" do
          it "should raise a Bongloy::Error::Api::InvalidRequestError" do
            expect_api_request(:invalid_request) do
              expect { subject.save! }.to raise_error(Bongloy::Error::Api::InvalidRequestError)
            end
          end
        end
      end
    end

    context "for an existing customer" do
      subject { build(:customer, :with_id, :with_card, :with_optional_params)}

      before do
        expect_api_request(:updated, :api_resource_id => subject.id) do
          subject.save!
        end
      end

      it "should update the remote customer" do
        request_body["card"].should == subject.card
        request_body["email"].should == subject.email
        request_body["description"].should == subject.description
      end
    end
  end

  describe "#retrieve!(query_params = {}, headers = {})" do
    subject { build(:customer, :with_id, :id => "cus_replace_me_with_an_customer_id") }

    it "should try to find the resource by the given id" do
      expect_api_request(:ok, :api_resource_id => subject.id) do
        subject.retrieve!
        subject.object.should == "customer"
      end
    end
  end
end
