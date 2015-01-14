require 'rspec'
require 'json_roa/client'
require 'pry'

describe JSON_ROA::Client do
  context 'when calling connect' do

    it 'returns an instance of JSON_ROA::Client::Relation' do
      expect(JSON_ROA::Client.connect('http://example.com').class).to \
        be == JSON_ROA::Client::Relation
    end

    it 'exposes Faraday::Connection via the block' do
      JSON_ROA::Client.connect('http://example.com') do |conn|
        expect(conn.class).to be == Faraday::Connection
      end
    end

  end
end
