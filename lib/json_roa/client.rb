require 'json_roa/client/version'
require 'json_roa/client/resource'
require 'faraday'
require 'faraday_middleware'

module JSON_ROA

  class VersionError < StandardError
  end

  class Middleware < Faraday::Middleware
    def call(env)
      @app.call(env).on_complete do |env|
        env.class.class_eval do |klass|
          attr_accessor :json_roa_data
        end
        content_type = env.response_headers['content-type']
        if  content_type  && content_type =~ /json-roa/
          if env.body.is_a? Array
            env.json_roa_data = env.body.first
            env.body.delete_at 0
          elsif env.body.is_a? Hash
            env.json_roa_data = env.body.delete('_json-roa')
          end
          json_roa_version = env.json_roa_data['version'] || env.json_roa_data['json-roa_version']
          major_version =
            begin
              Integer(/^(\d+).*/.match(json_roa_version)[1])
            rescue StandardError
              raise VersionError,
                'Failed to infer the major number of the JSON-ROA data.'
            end
          unless major_version == 1
            raise VersionError, 'The major version' \
              " #{major_version} is not supported by this client."
          end
        end
      end
    end
  end

  module Client

    DEFAULT_OPTIONS = {
      adapter: Faraday.default_adapter,
      raise_error: true,
      retry: true
    }

    class << self

      def connect(url, options = {}, &_block)
        options = DEFAULT_OPTIONS.merge(options)
        @conn = Faraday.new(
          url: url,
          headers: { accept: 'application/json-roa+json' }) do |conn|
            conn.use ::JSON_ROA::Middleware
            conn.response :json, content_type: /\bjson$/
            if options[:retry]
              conn.request :retry
            end
            if options[:raise_error]
              conn.use Faraday::Response::RaiseError
            end
            if options[:adapter]
              conn.adapter options[:adapter]
            end
          end

        yield @conn if block_given?
        Relation.new @conn, 'root', 'href' => url
      end

    end

  end

end
