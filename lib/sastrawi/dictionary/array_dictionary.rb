# frozen_string_literal: true

require 'set'

module Sastrawi
  module Dictionary
    class ArrayDictionary
      def initialize(words = [])
        @words = Set.new

        add_words(words)
      end

      ##
      # Return the words as an Array (for backward compatibility)

      def words
        @words.to_a
      end

      ##
      # Check whether a word is contained in the dictionary

      def contains?(word)
        @words.include?(word)
      end

      ##
      # Count how many words in the dictionary

      def count
        @words.size
      end

      ##
      # Add multiple words to the dictionary

      def add_words(new_words)
        new_words.each do |word|
          add(word)
        end
      end

      ##
      # Add a word to the dictionary

      def add(word)
        unless word.is_a?(String)
          raise ArgumentError, "dictionary entries must be strings, got #{word.class}"
        end

        return if word.strip == ''

        @words.add(word)
      end

      ##
      # Add words from a text file to the dictionary

      def add_words_from_text_file(file_path)
        words = []

        File.open(file_path, 'r') do |file|
          file.each do |line|
            words.push(line.chomp)
          end
        end

        add_words(words)
      end

      ##
      # Remove a word from the dictionary

      def remove(word)
        @words.delete(word)
      end
    end
  end
end
