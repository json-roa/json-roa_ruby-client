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

          relations= @resource.json_roa_data['collection']['relations'] rescue []

          relations.each do |key, data|
            yield Relation.new(@conn,key,data) if block_given? 
          end

          next_val= @resource.json_roa_data['collection']['next'] rescue nil

          if relations.empty? or (not next_val)
            break 
          else
            @resource= Relation.new(@conn,"next",next_val).get()
          end

        end

      end
    end

  end
end
