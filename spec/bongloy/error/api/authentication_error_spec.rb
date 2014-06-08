require 'spec_helper'

module Bongloy
  module Error
    module Api
      describe AuthenticationError do
        it_should_behave_like "an api error"

        describe "#message" do
          it "should have a default message" do
            subject.message.should == "No valid API key provided."
          end
        end
      end
    end
  end
end
