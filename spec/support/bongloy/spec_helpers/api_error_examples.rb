module Bongloy
  module SpecHelpers
    module ApiErrorExamples

      private

      shared_examples_for "an api error" do
        subject { build(factory_name) }

        let(:sample_errors) { "{\"error\":{\"type\":\"invalid_request_error\",\"amount\":[\"can't be blank\",\"must be greater than 0\"],\"base\":\"something happened\"}}" }

        describe "#initialize(options = {})" do
          subject { build(factory_name, :code => "321", :errors => sample_errors) }

          it "should allow initialization with a code and errors" do
            expect(subject.code).to eq("321")
            expect(subject.errors).to eq(sample_errors)
          end
        end

        describe "#message" do
          let(:message) { subject.message }

          context "with errors" do
            subject { build(factory_name, :errors => sample_errors) }
            it { expect(message).to match(/amount can't be blank, amount must be greater than 0, something happened/) }
          end

          context "without errors" do
            it { expect(message).not_to be_nil }
            it { expect(message).to be_a(String) }
          end

          context "with code" do
            subject { build(factory_name, :code => "401") }
            it { expect(message).to include(subject.code) }
          end

          context "with a custom message" do
            subject { build(factory_name, :message => "foo") }
            it { expect(message).to include("foo") }
          end
        end

        describe "#to_json" do
          let(:json) { JSON.parse(subject.to_json) }

          it "should return the errors in json format" do
            expect(json).to have_key("errors")
            expect(json).to have_key("code")
          end
        end

        describe "#to_hash" do
          let(:hash) { subject.to_hash }
          it "should return the errors in a hash" do
            expect(hash).to have_key("errors")
            expect(hash).to have_key("code")
          end
        end
      end
    end
  end
end
