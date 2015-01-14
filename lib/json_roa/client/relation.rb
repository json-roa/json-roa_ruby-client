require 'addressable/template'
require 'addressable/uri'

module JSON_ROA
  module Client
    class Relation

      attr_reader :data
      attr_reader :key

      def initialize(conn, key, data)
        @conn = conn
        @key = key
        @data = data

        Faraday::Connection::METHODS.intersection(available_methods) \
          .each do |method_name|
            define_http_method method_name
          end
      end

      def define_http_method(method_name)
        define_singleton_method method_name \
          do |query_parameters = {}, body = nil, headers = nil, &block|
        run_request method_name, query_parameters, body, headers, &block
        end
      end

      def assert_proper_query_parameters!(query_parameters, template)
        unless Set.new(query_parameters.keys).subset? Set.new(template.keys)
          raise StandardError, ['query_parameters', query_parameters.keys.to_s,
                                'do not match template parameters',
                                template.keys.to_s].join(' ')
        end
      end

      def run_request(method, query_parameters, body, headers, &block)
        href = @data['href']
        template = ::Addressable::Template.new(href)
        assert_proper_query_parameters! query_parameters, template
        expanded_url = template.expand(query_parameters)
        response = @conn.run_request( \
          method.to_sym, expanded_url, body, headers, &block)
        ::JSON_ROA::Client::Resource.new(@conn, response)
      end

      def available_methods_data
        @data['methods'] ||= { 'get' => {} }
      end

      def available_methods
        available_methods_data.keys.map(&:to_sym)
      end

      def to_s
        "#{self.class.name}:  #{@data}"
      end

    end

  end
end
