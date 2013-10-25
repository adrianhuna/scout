require 'spec_helper'

class ExampleWorker
  include Scout::Worker

  sidekiq_options queue: :test

  def instance_method
    # work hard
  end

  def self.class_method
    # work hard
  end

  perform_by :class_method
  perform_by :instance_method, on: :instance
end

describe Scout::Worker do
  describe '.perform_by' do
    let(:queue) { Sidekiq::Queue.new(:test) }

    before :each do
      queue.clear
    end

    context 'when using class method' do
      it 'enqueues a job' do
        expect(ExampleWorker).to respond_to(:original_class_method)

        ExampleWorker.class_method

        expect(queue.size).to eql(1)
      end
    end

    context 'when using instance method' do
      it 'enqueues a job' do
        expect(ExampleWorker.new).to respond_to(:original_instance_method)

        ExampleWorker.new.instance_method

        expect(queue.size).to eql(1)
      end
    end
  end
end

describe Scout::Worker::Base do
  describe '#register' do
    subject { described_class }

    context 'when registering class method' do
      it 'registers class method successfully' do
        base = double(:base)
        context = double(:class)

        expect(base).to receive(:singleton_class).and_return(context)
        expect(context).to receive(:send).with(:alias_method, :original_method, :method)
        expect(base).to receive(:send).with(:define_method, :perform)
        expect(context).to receive(:send).with(:define_method, :method)

        subject.new(base, :method).register
      end
    end

    context 'when registering instance method' do
      it 'registers instance method successfully' do
        base = double(:base)

        expect(base).to receive(:send).with(:alias_method, :original_method, :method)
        expect(base).to receive(:send).with(:define_method, :perform)
        expect(base).to receive(:send).with(:define_method, :method)

        subject.new(base, :method, on: :instance).register
      end
    end
  end
end
