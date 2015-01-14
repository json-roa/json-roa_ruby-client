module JSON_ROA
  module Client

    class Collection
      include Enumerable

      def initialize conn, resource
        @conn= conn
        @resource= resource
      end

      def each &block

        while true do 

          relations= collection_data['relations'] rescue []

          relations.each do |key, data|
            yield Relation.new(@conn,key,data) if block_given? 
          end

          next_val= collection_data['next'] rescue nil

          if relations.empty? or (not next_val)
            break 
          else
            @resource= Relation.new(@conn,"next",next_val).get()
          end

        end

      end

      def collection_data
        @resource.json_roa_data['collection']
      end

      def to_s 
        "#{self.class.name}: #{collection_data}"
      end

    end

  end
end
