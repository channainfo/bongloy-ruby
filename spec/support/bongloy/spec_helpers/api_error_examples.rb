module Bongloy
  module SpecHelpers
    module ApiErrorExamples

      private

      shared_examples_for "an api error" do
        subject { build(factory_name) }

        let(:sample_errors) { "{\"error\":{\"amount\":[\"can't be blank\",\"must be greater than 0\"],\"base\":\"something happened\"}}" }

        describe "#initialize(options = {})" do
          subject { build(factory_name, :code => "321", :errors => sample_errors) }

          it "should allow initialization with a code and errors" do
            subject.code.should == "321"
            subject.errors.should == sample_errors
          end
        end

        describe "#message" do
          let(:message) { subject.message }

          context "with errors" do
            subject { build(factory_name, :errors => sample_errors) }

            it "should generate the message from the errors" do
              message.should =~ /amount can't be blank, amount must be greater than 0, something happened/
            end
          end

          context "without errors" do
            it "should have a default" do
              message.should_not be_nil
            end

            it "should return a string" do
              message.should be_a(String)
            end
          end

          context "with code" do
            subject { build(factory_name, :code => "401") }

            it "should include the error code" do
              message.should include(subject.code)
            end
          end

          context "with a custom message" do
            subject { build(factory_name, :message => "foo") }

            it "should override the default message with the custom message" do
              message.should include("foo")
            end
          end
        end

        describe "#to_json" do
          let(:json) { JSON.parse(subject.to_json) }

          it "should return the errors in json format" do
            json.should have_key("errors")
            json.should have_key("code")
          end
        end

        describe "#to_hash" do
          let(:hash) { subject.to_hash }
          it "should return the errors in a hash" do
            hash.should have_key("errors")
            hash.should have_key("code")
          end
        end
      end
    end
  end
end
