# frozen_string_literal: true

module Sastrawi
  module Stemmer
    module Filter
      class TextNormalizer
        def self.normalize_text(text)
          return "" if text.nil?

          unless text.is_a?(String)
            raise ArgumentError, "expected a String, got #{text.class}"
          end

          return "" if text.empty?

          lowercase_text = text.downcase
          replaced_text = lowercase_text.gsub(/[^a-z0-9 -]/im, ' ')
          replaced_text = replaced_text.gsub(/( +)/im, ' ')

          replaced_text.strip
        end
      end
    end
  end
end
