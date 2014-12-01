require "json_roa/client/relation"
require "json_roa/client/collection"

module JSON_ROA
  module Client

    class Resource

      attr_reader :response

      def initialize conn, response = nil
        @conn= conn
        @response= response || conn.get
      end

      def relation key
        relhash= @response.env.json_roa_data['relations'][key]
        ::JSON_ROA::Client::Relation.new @conn, key, relhash
      end

      def data
        @response.body
      end

      def json_roa_data
        @response.env.json_roa_data
      end

      def collection
        ::JSON_ROA::Client::Collection.new @conn, self 
      end
    end

  end
end

