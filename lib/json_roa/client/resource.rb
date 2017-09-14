require 'json_roa/client/relation'
require 'json_roa/client/collection'

module JSON_ROA
  module Client

    class Resource

      attr_reader :conn
      attr_reader :response

      def initialize(conn, response = nil)
        @conn = conn
        @response = response || conn.get
      end

      def relation(key)
        relhash = json_roa_data['relations'][key]
        ::JSON_ROA::Client::Relation.new @conn, key, relhash
      end

      def self_relation
        ::JSON_ROA::Client::Relation.new( \
          @conn, 'self', json_roa_data['self-relation']) rescue nil
      end

      def data
        @response.body.instance_eval do
          self.with_indifferent_access rescue self
        end
      end

      def json_roa_data
        @response.env.json_roa_data.instance_eval do
          self.with_indifferent_access rescue self
        end
      end

      def collection
        ::JSON_ROA::Client::Collection.new @conn, self
      end

      def to_s
        "#{self.class.name}: #{data} #{json_roa_data}"
      end

    end

  end
end
