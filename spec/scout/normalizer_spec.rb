require 'spec_helper'

describe Scout::Normalizer::Base do
  subject { described_class }

  describe '.value' do
    context 'when normalizing blank string' do
      it 'returns nil' do
        expect(subject.value('       ')).to be_nil
      end
    end

    context 'when normalizing string' do
      it 'trims string whitespaces' do
        expect(subject.value('example        string   ')).to eql('example string')
      end
    end
  end
end
