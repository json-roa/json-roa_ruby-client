module JSON_ROA
  module Client

    class Collection
      include Enumerable

      def initialize conn, resource
        @conn= conn
        @resource= resource
      end

      def each &block
        relations= @resource.response.env \
          .json_roa_data['collection']['relations'] rescue []
        relations.each do |key, data|
          yield Relation.new(@conn,key,data) if block_given? 
        end

        next_val= @resource.response \
          .env.json_roa_data['collection']['next'] rescue nil
        if next_val 
          Relation.new(@conn,"next",next_val).get().collection.each(&block)
        end

      end
    end

  end
end
