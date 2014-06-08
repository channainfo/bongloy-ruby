require 'spec_helper'

module Bongloy
  module ApiResource
    describe Customer do
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

      describe "#save!" do
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
    end
  end
end
