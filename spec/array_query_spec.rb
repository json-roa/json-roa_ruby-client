require_relative 'spec_helper.rb'

describe 'API: requesting an array object' do

  describe 'array relation' do

    let :array do
      JSON_ROA::Client.connect('http://localhost/array')
    end

    describe 'array_resource via get' do

      it do
        expect(array.get.data).to be == [{ 'x' => 42 }]
      end

    end
  end
end
