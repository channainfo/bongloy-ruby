module Bongloy
  module SpecHelpers
    class EnvHelpers
      def stub_env(key, value)
        ENV.stub(:[]).and_call_original
        ENV.stub(:[]).with(key).and_return(value.to_s)
      end
    end
  end
end
