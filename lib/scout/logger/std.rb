module Scout
  module Logger
    class Std
      def self.out
        $stdout
      end

      def self.err
        $stderr
      end
    end
  end
end
