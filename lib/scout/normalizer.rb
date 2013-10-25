module Scout
  module Normalizer
    extend ActiveSupport::Concern

    included do
      include Scout::Normalizer::ClassMethods
    end

    module ClassMethods
      def normalizer
        @normalizer ||= Class.new { include Base }
      end
    end

    module Base
      extend self

      def value(value)
        value = value.strip.squeeze(' ')

        value unless value.blank?
      end
    end
  end
end
