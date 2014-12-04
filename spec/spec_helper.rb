require 'simplecov'
SimpleCov.start

require 'faraday'
require 'rspec'
require 'pry'
require 'YAML'
require 'json_roa/client'

module JSON_ROA
  module Client

    class Relation
      attr_accessor :conn
    end

    class << self
      alias_method :original_connect, :connect

      def connect url, &block
        res= original_connect url, &block
        res.conn= test_api
        res
      end

    end
  end
end


def root_data 
  YAML.load_file(File.expand_path("./data/root.yml",
                                  File.dirname(__FILE__)))
end

def tasks_page0_data 
  YAML.load_file( File.expand_path("./data/tasks_page0.yml",
                                   File.dirname(__FILE__)))
end

def tasks_page1_data
  YAML.load_file( File.expand_path("./data/tasks_page1.yml",
                                   File.dirname(__FILE__)))
end

def task1_data 
  YAML.load_file( File.expand_path("./data/task1.yml",
                                   File.dirname(__FILE__)))
end


def test_api
  Faraday.new do |conn|
    headers= {content_type: "application/json-roa+json"}
    conn.use ::JSON_ROA::Middleware
    conn.response :json, :content_type => /\bjson$/
    conn.adapter :test do |stub|
      stub.get('/') { |env| [ 200, headers, root_data.to_json]}
      stub.get('/tasks/') { |env| [ 200, headers, tasks_page0_data.to_json]}
      stub.get('/tasks/?page=0') { |env| [ 200, headers, tasks_page0_data.to_json]}
      stub.get('/tasks/?page=1') { |env| [ 200, headers, tasks_page1_data.to_json]}
      stub.get('/tasks/t1') { |env| [ 200, headers, task1_data.to_json]}
    end
  end
end
