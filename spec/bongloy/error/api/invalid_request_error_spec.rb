require 'spec_helper'

module Bongloy
  module Error
    module Api
      describe InvalidRequestError do
        it_should_behave_like "an api error"

        describe "#message" do
          it "should have a default" do
            subject.message.should == "Bad Request."
          end
        end
      end
    end
  end
end
