module Bongloy
  module SpecHelpers
    module ApiResourceExamples
      shared_examples_for "a bongloy api resource" do

        describe "#initialize(options = {})" do
          context "passing an :api_key" do
            let(:api_key) { "pk_test_12345" }

            subject { described_class.new(:api_key => api_key) }

            it "should set the api_key" do
              subject.api_key.should == api_key
            end
          end

          context "without passing an :api_key" do
            it "should set the api key to whatever is in ENV['BONGLOY_SECRET_KEY']" do
              subject.api_key.should == ENV["BONGLOY_SECRET_KEY"]
            end
          end
        end

        describe "#save!" do
          context "for unpersisted resources" do
            it "should create a bongloy resource" do
              subject.save!
            end
          end
        end
      end
    end
  end
end
