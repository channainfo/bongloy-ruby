module Bongloy
  module SpecHelpers
    class EnvHelpers
      def stub_env(key, value)
        allow(ENV).to_receive(:[]).and_call_original
        allow(ENV).to_receive(:[]).with(key).and_return(value.to_s)
      end
    end
  end
end
