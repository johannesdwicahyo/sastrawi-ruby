# frozen_string_literal: true

module Sastrawi
  module Stemmer
    module Cache
      class ArrayCache
        DEFAULT_MAX_SIZE = 10_000

        attr_reader :max_size

        def initialize(max_size: DEFAULT_MAX_SIZE)
          @data = {}
          @mutex = Mutex.new
          @max_size = max_size
        end

        def data
          @mutex.synchronize { @data.dup }
        end

        def set(key, value)
          @mutex.synchronize do
            evict_if_full
            @data[key.to_sym] = value
          end
        end

        def get(key)
          @mutex.synchronize do
            @data[key.to_sym] if @data.key?(key.to_sym)
          end
        end

        def has?(key)
          @mutex.synchronize do
            @data.key?(key.to_sym)
          end
        end

        def size
          @mutex.synchronize { @data.size }
        end

        def clear!
          @mutex.synchronize { @data.clear }
        end

        private

        def evict_if_full
          return if @data.size < @max_size

          # Remove the oldest entry (first inserted key)
          oldest_key = @data.keys.first
          @data.delete(oldest_key)
        end
      end
    end
  end
end
