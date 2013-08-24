require 'spec_helper'

describe Scout::Logger do
  before :each do
    # we don't want colors now
    (Colored::COLORS.keys + Colored::EXTRAS.keys).each do |color|
      String.instance_eval { define_method(color.to_sym) { self } }
     end
  end

  context 'when logging' do
    subject { Scout::Logger::Log }

    it 'should properly log message' do
      base   = double.as_null_object
      stream = double(:stream)

      base.should_receive(:name).and_return('name')
      stream.should_receive(:write).with do |message|
        message.should include("name: message\n")
      end

      logger = subject.new(base)
      logger.verbose = true
      logger.write(stream, 'message')
    end
  end
end
