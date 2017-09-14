require_relative 'spec_helper.rb'

describe 'version check' do

  describe 'missing version' do
    it 'raises' do
      expect do
        JSON_ROA::Client.connect('http://localhost/missing-version').get
      end.to raise_error JSON_ROA::VersionError
    end
  end

  describe 'malformed version' do
    it 'raises' do
      expect do
        JSON_ROA::Client.connect('http://localhost/malformed-version').get
      end.to raise_error JSON_ROA::VersionError
    end
  end

  describe 'incompatible version' do
    it 'raises' do
      expect do
        JSON_ROA::Client.connect('http://localhost/incompatible-version').get
      end.to raise_error JSON_ROA::VersionError
    end
  end
end
