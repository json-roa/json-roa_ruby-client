require 'json_roa/client/version'
require 'json_roa/client/resource'
require 'faraday'
require 'faraday_middleware'

module JSON_ROA

  class Middleware < Faraday::Middleware
    def call(env)
      @app.call(env).on_complete do |env|
        env.class.class_eval do |klass|
          attr_accessor :json_roa_data
        end
        if env.body.is_a? Array
          env.json_roa_data = env.body.first
          env.body.delete_at 0
        elsif env.body.is_a? Hash
          env.json_roa_data = env.body.delete('_json-roa')
        end
      end
    end
  end

  module Client

    class << self

      def connect(url, &_block)
        @conn = Faraday.new(
          url: url,
          headers: { accept: 'application/json-roa+json' }) do |conn|
            conn.use ::JSON_ROA::Middleware
            conn.response :json, content_type: /\bjson$/
            conn.request :retry
            conn.use Faraday::Response::RaiseError
            conn.adapter Faraday.default_adapter
          end

        yield @conn if block_given?
        Relation.new @conn, 'root', 'href' => url
      end

    end

  end

end
