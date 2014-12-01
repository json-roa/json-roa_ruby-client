require 'addressable/template'
require 'addressable/uri'

module JSON_ROA
  module Client

    class Relation

      SUPPORTED_METHODS= %w(get put post delete)

      attr_reader :data
      attr_reader :key

      def initialize conn, key, data 
        @conn= conn
        @key= key
        @data= data
      end

      def run_request method, query_parameters, body, headers, &block
        unless available_methods.keys.include? method
          raise ArgumentError, "method: #{method} is not supported by this relation"
        end
        href= @data['href']
        template= ::Addressable::Template.new(href) 
        expanded_url= template.expand(query_parameters)
        response=@conn.run_request method.to_sym, expanded_url, body, headers, &block
        ::JSON_ROA::Client::Resource.new(@conn,response)
      end

      SUPPORTED_METHODS.each do |method_name|  
        define_method method_name do |query_parameters={}, body=nil, headers=nil, &block|
          run_request method_name, query_parameters, body, headers, &block
        end
      end

      def available_methods
        @data['methods'] ||= {"get" => {}}
      end

    end

  end
end

