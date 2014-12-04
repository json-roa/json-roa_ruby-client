require_relative 'spec_helper.rb'

describe "template expansion of task with id" do

  let :root_relation do 
    JSON_ROA::Client.connect("/")
  end

  subject(:task_relation) {root_relation.get().relation("task")}

  it "is a relation" do 
    expect(task_relation.class).to be== JSON_ROA::Client::Relation
  end

  it "is templated" do
    expect(task_relation.data['href']).to be== "/tasks/{id}"
  end

  describe "get with parameter to expand" do
    subject(:task_resource){task_relation.get(id: "t1")}

    it "is a resource of t1" do
      expect(task_resource.class).to be== JSON_ROA::Client::Resource
      expect(task_resource.self_relation.data["href"]).to be== "/tasks/t1"
    end

  end

end


