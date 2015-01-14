require_relative 'spec_helper.rb'

describe 'template expansion' do

  let :root_relation do
    JSON_ROA::Client.connect('/')
  end

  context 'task relation' do

    subject(:task_relation) { root_relation.get.relation('task') }

    it 'is a relation' do
      expect(task_relation.class).to be == JSON_ROA::Client::Relation
    end

    it 'is templated' do
      expect(task_relation.data['href']).to be == '/tasks/{id}'
    end

    describe 'get with parameter to expand' do
      subject(:task_resource) { task_relation.get('id' => 't1') }

      it 'is a resource of t1' do
        expect(task_resource.class).to be == JSON_ROA::Client::Resource
        expect(task_resource.self_relation.data['href']).to be == '/tasks/t1'
      end

    end

  end

  context 'tasks relation' do

    subject(:tasks_relation) { root_relation.get.relation('tasks') }

    describe 'get with existing parameter to expand' do
      it 'does not raise an error' do
        expect do
          tasks_relation.get('x' => 'foo')
        end.not_to raise_error
      end
    end

    describe 'get with a non-existing parameter to expand' do
      it 'raises an error' do
        expect do
          tasks_relation.get('non_existing_query_parameter' => 'foo')
        end.to raise_error /query_parameters .* do not match template parameters/
      end
    end

  end

end
