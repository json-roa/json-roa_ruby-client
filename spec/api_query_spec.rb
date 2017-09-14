require_relative 'spec_helper.rb'

describe 'API: traversing from root to resource to some relation' do

  describe 'root relation' do

    let :root_relation do
      JSON_ROA::Client.connect('http://localhost/')
    end

    describe 'root_resource via get' do

      subject(:root_resource) { root_relation.get }

      it do
        expect(root_resource.class).to be == JSON_ROA::Client::Resource
      end

      describe 'data' do
        subject(:data) { root_resource.data }

        it do
          expect(data).to be == { 'x' => 42 }
        end

      end

      describe 'task relation ' do
        subject(:task_relation) { root_resource.relation('task') }

        it 'is of class Relation' do
          expect(task_relation.class).to be == JSON_ROA::Client::Relation
        end

        it 'responds to get' do
          expect(task_relation.respond_to? :get).to be
        end

      end

    end

  end

end
