# TODO (smolnar)
# * create custom handlers for preprocessing args
# * add option to specify context which method run on (class or instance)
# * figure out specs

module Scout
  module Worker
    extend ActiveSupport::Concern

    included do
      include Sidekiq::Worker

      sidekiq_options backtrace: true
    end

    module ClassMethods
      def worker
        @worker
      end

      def perform_by(method, options = {})
        @worker = Base.new(self, method, options)

        @worker.register
      end
    end

    class Base
      attr_reader :base, :method, :options

      def initialize(base, method, options = {})
        @base    = base
        @method  = method
        @options = options
      end

      def register
        context = options[:on] == :instance ? base : base.singleton_class

        original_method = :"original_#{method}"

        context.send(:alias_method, original_method, method)

        base.send(:define_method, :perform) do |*args|
          context.send(original_method, *args)
        end

        context.send(:define_method, method) do |*args|
          target = self.is_a?(Class) ? self : self.class

          target.perform_async(*args)
        end
      end
    end
  end
end
