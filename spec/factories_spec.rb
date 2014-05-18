require 'spec_helper'

describe "Factories" do
  describe "all of them" do
    it "should be valid" do
      FactoryGirl.lint
    end
  end
end
