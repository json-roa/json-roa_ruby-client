require_relative 'spec_helper.rb'

describe 'methods of the relation /tasks/t1' do

  let :root_relation do
    JSON_ROA::Client.connect('/')
  end

  subject(:task1_self_relation) \
    { root_relation.get.relation('task').get('id' => 't1').self_relation }

  it 'is a relation' do
    expect(task1_self_relation.class).to be == JSON_ROA::Client::Relation
  end

  describe 'defined get' do
    it 'does not raise' do
      expect { task1_self_relation.get }.not_to raise_error
    end
  end

  describe 'not defined post' do
    it 'does raise' do
      expect { task1_self_relation.post }.to raise_error
    end
  end

end
