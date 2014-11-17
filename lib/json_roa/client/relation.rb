require 'addressable/template'
require 'addressable/uri'

module JSON_ROA
  module Client

    class Relation

      attr_reader :data
      attr_reader :key

      def initialize conn, key, data 
        @conn= conn
        @key= key
        @data= data
      end

      def get query_parameters= {}
        href= @data['href']
        template= ::Addressable::Template.new(href) 
        expanded= template.expand(query_parameters)
        response=@conn.get(expanded)
        ::JSON_ROA::Client::Resource.new(@conn,response)
      end

      def methods 
        @data['methods']
      end

    end

  end
end

