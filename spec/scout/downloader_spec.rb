require 'spec_helper'
require 'scout/downloader'

describe Scout::Downloader do
  let(:downloader) { Scout::Downloader.new }

  it 'should download url and return content of page' do
    block = double(:block)
    block.should_receive(:headers=).with('User-Agent' => :user_agent)
    block.should_receive(:cookies=).with('a=1;b=2')
    block.should_receive(:follow_location=).with(true)
    block.should_receive(:proxy_url=).with('proxy://proxy')

    response = double(:response)
    response.should_receive(:code).and_return(200)
    response.should_receive(:body).twice.and_return('content')

    adapter = double.as_null_object
    adapter.should_receive(:get).with('url').and_yield(block).and_return(response)

    downloader.adapter      = adapter
    downloader.cache.enable = false

    downloader.add_header(:user_agent, :user_agent)
    downloader.add_cookie(:a, 1)
    downloader.add_cookie(:b, 2)
    downloader.proxy_url = 'proxy://proxy'

    content = downloader.download('url')

    content.body.should eql('content')
  end

  context 'when caching' do
    it 'should load response from cache' do
      cache = double(:cache)

      cache.should_receive(:enabled?).and_return(true)
      cache.should_receive(:exists?).with('url').and_return(true)
      cache.should_receive(:get).with('url').and_return('content')

      downloader.cache = cache

      downloader.download('url')
    end

    it 'should store response in cache' do
      response = double(:response)
      response.should_receive(:body).exactly(3).and_return('content')
      response.should_receive(:code).and_return(200)

      cache = double(:cache)
      cache.should_receive(:enabled?).twice.and_return(true)
      cache.should_receive(:exists?).with('url').and_return(false)
      cache.should_receive(:store).with('url', response.body).and_return(true)

      adapter = double.as_null_object
      adapter.should_receive(:get).with('url').and_return(response)

      downloader.adapter = adapter
      downloader.cache   = cache

      downloader.download('url')
    end
  end
end
