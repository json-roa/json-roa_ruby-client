require "json_roa/client/version"

require "json_roa/client/resource"


require 'faraday'
require 'faraday_middleware'

module JSON_ROA

  class Middleware < Faraday::Middleware
    def call(env)
      @app.call(env).on_complete do |env|
        env.class.class_eval do |klass|
          attr_accessor :json_roa_data
        end
        env.json_roa_data= env.body.delete("_json-roa")
      end
    end
  end

  module Client

    class << self 

      def connect url, &block 

        @conn= Faraday.new(url: url,
                              headers: {accept: "application/json-roa+json"}) do |conn|
          conn.use ::JSON_ROA::Middleware
          conn.response :json, :content_type => /\bjson$/
          conn.use Faraday::Response::RaiseError
          conn.request :retry
          conn.adapter Faraday.default_adapter  
        end

        yield @conn if block_given?

        Resource.new @conn

      end

    end
  end

end
