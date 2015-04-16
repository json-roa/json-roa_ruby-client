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

      def connect(url, &block)
        res = original_connect url, &block
        res.conn = test_api
        res
      end

    end
  end
end

def load_yaml_file(filepath)
  YAML.load_file(
    File.expand_path(filepath, File.dirname(__FILE__)))
end

def root_data
  load_yaml_file './data/root.yml'
end

def tasks_page0_data
  load_yaml_file './data/tasks_page0.yml'
end

def tasks_page1_data
  load_yaml_file './data/tasks_page1.yml'
end

def task1_data
  load_yaml_file './data/task1.yml'
end

def array_data
  load_yaml_file './data/array.yml'
end

def test_api
  Faraday.new do |conn|
    headers = { content_type: 'application/json-roa+json' }
    conn.use ::JSON_ROA::Middleware
    conn.response :json, content_type: /\bjson$/
    conn.adapter :test do |stub|
      stub.get('/') do |env|
        [200, headers, root_data.to_json]
      end
      stub.get('/tasks/') do |env|
        [200, headers, tasks_page0_data.to_json]
      end
      stub.get('/tasks/?page=0') do |env|
        [200, headers, tasks_page0_data.to_json]
      end
      stub.get('/tasks/?page=1') do |env|
        [200, headers, tasks_page1_data.to_json]
      end
      stub.get('/tasks/t1') do |env|
        [200, headers, task1_data.to_json]
      end
      stub.get('/array') do |env|
        [200, headers, array_data.to_json]
      end
      stub.get('/missing-version') do |env|
        [200, headers, { '_json-roa' => {} }]
      end
      stub.get('/malformed-version') do |env|
        [200, headers, { '_json-roa' => { 'json-roa_version' => 'X1.0.0' } }]
      end
      stub.get('/incompatible-version') do |env|
        [200, headers, { '_json-roa' => { 'json-roa_version' => '5.0.0' } }]
      end
    end
  end
end
