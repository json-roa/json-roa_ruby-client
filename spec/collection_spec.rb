require_relative 'spec_helper.rb'

describe JSON_ROA::Client::Collection do

  let :root_relation do 
    JSON_ROA::Client.connect("/")
  end

  describe "tasks resource via get" do
    subject(:tasks_resource) {root_relation.get().relation('tasks').get() }

    it "is a resource" do
      expect(tasks_resource.class).to be== JSON_ROA::Client::Resource
    end

    it "responds to collection" do
      expect(tasks_resource.respond_to? :collection).to be
    end

    describe "tasks collection" do
      subject(:tasks_collection) {tasks_resource.collection}

      it "is a collection" do
        expect(tasks_collection.class).to be== JSON_ROA::Client::Collection
      end

      it "has exactly one element" do 
        expect(tasks_collection.count).to be== 1
      end

      describe "the first task" do
        subject(:first_task) {tasks_collection.first}

        it "is a relation" do
          expect(first_task.class).to be== JSON_ROA::Client::Relation
        end

        it "leads to /task/t1" do
          expect(first_task.data["href"]).to be== "/tasks/t1"
        end

      end

    end

  end

end

