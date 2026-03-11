# frozen_string_literal: true

require 'sastrawi/dictionary/array_dictionary'
require 'sastrawi/stop_word_remover/stop_word_remover'

module Sastrawi
  module StopWordRemover
    class StopWordRemoverFactory
      STOP_WORDS_FILE = File.join(File.dirname(__FILE__), '..', '..', '..', 'data', 'stop-words.txt')

      def create_stop_word_remover
        stop_words = get_stop_word
        dictionary = Sastrawi::Dictionary::ArrayDictionary.new(stop_words)
        Sastrawi::StopWordRemover::StopWordRemover.new(dictionary)
      end

      def get_stop_word
        if File.exist?(STOP_WORDS_FILE)
          File.readlines(STOP_WORDS_FILE, chomp: true).reject(&:empty?)
        else
          default_stop_words
        end
      end

      private

      def default_stop_words
        %w[yang dan di ini itu dengan untuk dari pada adalah ke
           tidak ada juga akan tetapi oleh atau sudah saya kami
           mereka dia ia anda kita bisa harus lebih sangat
           telah belum masih sedang bahwa karena jika maka
           saat ketika setelah sebelum antara namun walau meski]
      end
    end
  end
end
