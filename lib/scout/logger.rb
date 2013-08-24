module Scout
  module Logger
    include Squire
    extend ActiveSupport::Concern

    def logger
      self.class.logger
    end

    module ClassMethods
      def logger
        @logger ||= Log.new(self)
      end
    end

    class Log
      attr_accessor :base, :output, :verbose

      alias :kernel_raise :raise

      def initialize(base)
        @base  = base
      end

      def output
        @output ||= Logger.config.output
      end

      def verbose
        @verbose.nil? ? Logger.config.verbose : @verbose
      end

      def verbose?
        !!verbose
      end

      def log(str, options = {})
        write(output.out, str, options)
      end

      def warn(str, options = {})
        write(output.err, str.yellow, options)
      end

      def error(str, options = {})
        write(output.err, str.red, options)
      end

      def raise(excetion, options = {})
        error(exception.message, options)

        kernel_raise(exception)
      end

      def before(str, options = {})
        @time = Time.now

        log("#{str} ... ", options.merge(newline: false))
      end

      def after(str = 'done', options = {})
        str = str.green.bold

        if @time
          elapsed = (Time.now - @time) * 1000.0

          str = "#{str} (#{elapsed.round(3)} ms)"
        else
          warn "There's no #before called before #after, ommiting time." if @time
        end

        log(str, prefix: false)
      end

      def write(stream, str, options = {})
        stream.write(format(str, options)) if verbose?
      end

      private

      def format(str, options = {})
        options[:prefix]  = true if options[:prefix].nil?
        options[:newline] = true if options[:newline].nil?

        "#{"#{prefix}: ".bold if options[:prefix]}#{str}#{"\n" if options[:newline]}"
      end

      def prefix
        time   = Time.now.strftime('%Y-%m-%d %H:%M:%S')
        caller = base.respond_to?(:name) ? base.name : base.class.name

        "[#{time}] #{caller.bold}"
      end
    end
  end
end
