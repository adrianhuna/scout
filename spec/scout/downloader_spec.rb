require 'spec_helper'
require 'scout/downloader'

describe Scout::Downloader do
  subject { Scout::Downloader }

  let(:url) { 'http://example.com' }
  let(:curl) { double(:curl ) }

  describe '.download' do
    context 'when page is available' do
      it 'downloads a content of a page' do
        config = double(:config)

        expect(config).to receive(:headers=).with('User-Agent' => :agent)
        expect(config).to receive(:cookies=).with('a=1;b=2')
        expect(config).to receive(:follow_location=).with(true)
        expect(config).to receive(:proxy_url=).with('proxy://proxy')

        response = double(:response, response_code: 200, body_str: 'content')

        expect(curl).to receive(:get).with(url).and_yield(config).and_return(response)

        options = {
          headers: { user_agent: :agent },
          cookies: { a: 1, b: 2 },
          proxy_url: 'proxy://proxy'
        }

        stub_const('Curl', curl)

        content = subject.download(url, options)

        expect(content).to eql('content')
      end
    end

    context 'when page is not available' do
      it 'raises an error' do
        response = double(:response, response_code: 404)

        expect(curl).to receive(:get).with(url).and_return(response)

        stub_const('Curl', curl)

        expect { subject.download(url, times: 1) }.to raise_error Scout::Downloader::HTTPError, /404/
      end
    end
  end
end
