# frozen_string_literal: true

require 'spec_helper'

require 'sastrawi/dictionary/array_dictionary'
require 'sastrawi/stemmer/stemmer_factory'
require 'sastrawi/stemmer/cache/array_cache'
require 'set'

##
# Tests for v0.2.1 fixes:
# - Nil/empty input handling
# - Non-string input validation
# - Set-based dictionary performance
# - Thread safety (concurrent stemming)
# - Cache size limit and clear_cache!

describe 'Robustness fixes (v0.2.1)' do
  let(:factory) { Sastrawi::Stemmer::StemmerFactory.new }
  let(:stemmer) { factory.create_stemmer }

  # ── Nil / empty input handling ──────────────────────────────────────

  describe 'nil and empty input handling' do
    it 'Stemmer#stem returns "" for nil' do
      expect(stemmer.stem(nil)).to eq("")
    end

    it 'Stemmer#stem returns "" for empty string' do
      expect(stemmer.stem("")).to eq("")
    end

    it 'Stemmer#stem returns "" for whitespace-only string' do
      expect(stemmer.stem("   ")).to eq("")
    end

    it 'plain Stemmer#stem returns "" for nil' do
      dict = Sastrawi::Dictionary::ArrayDictionary.new(%w[tes])
      plain = Sastrawi::Stemmer::Stemmer.new(dict)
      expect(plain.stem(nil)).to eq("")
    end

    it 'plain Stemmer#stem returns "" for empty string' do
      dict = Sastrawi::Dictionary::ArrayDictionary.new(%w[tes])
      plain = Sastrawi::Stemmer::Stemmer.new(dict)
      expect(plain.stem("")).to eq("")
    end
  end

  # ── Non-string input validation ─────────────────────────────────────

  describe 'non-string input validation' do
    it 'Stemmer#stem raises ArgumentError for Integer input' do
      expect { stemmer.stem(123) }.to raise_error(ArgumentError)
    end

    it 'Stemmer#stem raises ArgumentError for Symbol input' do
      expect { stemmer.stem(:hello) }.to raise_error(ArgumentError)
    end

    it 'Stemmer#stem raises ArgumentError for Array input' do
      expect { stemmer.stem(["a"]) }.to raise_error(ArgumentError)
    end

    it 'ArrayDictionary#add raises ArgumentError for non-string' do
      dict = Sastrawi::Dictionary::ArrayDictionary.new
      expect { dict.add(123) }.to raise_error(ArgumentError)
    end

    it 'ArrayDictionary#add raises ArgumentError for nil' do
      dict = Sastrawi::Dictionary::ArrayDictionary.new
      expect { dict.add(nil) }.to raise_error(ArgumentError)
    end
  end

  # ── Set-based dictionary (O(1) lookup) ──────────────────────────────

  describe 'Set-based dictionary lookup' do
    it 'uses Set internally for O(1) lookups' do
      dict = Sastrawi::Dictionary::ArrayDictionary.new(%w[satu dua tiga])

      # The internal @words should be a Set
      internal = dict.instance_variable_get(:@words)
      expect(internal).to be_a(Set)
    end

    it 'contains? works correctly after conversion to Set' do
      dict = Sastrawi::Dictionary::ArrayDictionary.new(%w[satu dua tiga])

      expect(dict.contains?('satu')).to be true
      expect(dict.contains?('empat')).to be false
    end

    it 'does not store duplicate words' do
      dict = Sastrawi::Dictionary::ArrayDictionary.new(%w[satu satu satu])
      expect(dict.count).to eq(1)
    end

    it 'words accessor returns an Array for backward compatibility' do
      dict = Sastrawi::Dictionary::ArrayDictionary.new(%w[satu dua])
      expect(dict.words).to be_a(Array)
      expect(dict.words.sort).to eq(%w[dua satu])
    end

    it 'remove works with Set' do
      dict = Sastrawi::Dictionary::ArrayDictionary.new(%w[satu dua tiga])
      dict.remove('dua')
      expect(dict.contains?('dua')).to be false
      expect(dict.count).to eq(2)
    end
  end

  # ── Array mutation fix (restore_prefix) ─────────────────────────────

  describe 'array mutation fix in restore_prefix' do
    it 'does not skip elements when removing DP removals' do
      # This is tested indirectly: stemming still works correctly for words
      # that exercise the restore_prefix path (ECS loop last return).
      # These words require prefix restoration during stemming.
      expect(stemmer.stem('bersembunyi')).to eq('sembunyi')
      expect(stemmer.stem('pelanggan')).to eq('langgan')
      expect(stemmer.stem('perbaikan')).to eq('baik')
      expect(stemmer.stem('kebaikannya')).to eq('baik')
    end
  end

  # ── Thread safety ───────────────────────────────────────────────────

  describe 'thread safety' do
    it 'handles concurrent stemming without errors' do
      words = %w[membangun mencintai berlari perbaikan kebaikannya pelanggan]
      expected = %w[bangun cinta lari baik baik langgan]
      errors = []
      threads = []

      20.times do
        threads << Thread.new do
          words.each_with_index do |word, i|
            result = stemmer.stem(word)
            unless result == expected[i]
              errors << "Expected #{expected[i]} for #{word}, got #{result}"
            end
          end
        rescue => e
          errors << e.message
        end
      end

      threads.each(&:join)
      expect(errors).to be_empty
    end
  end

  # ── Cache behavior ──────────────────────────────────────────────────

  describe 'cache behavior' do
    it 'has a default max_size of 10_000' do
      cache = Sastrawi::Stemmer::Cache::ArrayCache.new
      expect(cache.max_size).to eq(10_000)
    end

    it 'accepts a custom max_size' do
      cache = Sastrawi::Stemmer::Cache::ArrayCache.new(max_size: 5)
      expect(cache.max_size).to eq(5)
    end

    it 'evicts oldest entry when cache is full' do
      cache = Sastrawi::Stemmer::Cache::ArrayCache.new(max_size: 3)

      cache.set('a', 1)
      cache.set('b', 2)
      cache.set('c', 3)
      expect(cache.size).to eq(3)

      cache.set('d', 4)
      expect(cache.size).to eq(3)
      expect(cache.has?('a')).to be false  # oldest evicted
      expect(cache.has?('d')).to be true   # newest kept
    end

    it 'clear! empties the cache' do
      cache = Sastrawi::Stemmer::Cache::ArrayCache.new
      cache.set('a', 1)
      cache.set('b', 2)
      expect(cache.size).to eq(2)

      cache.clear!
      expect(cache.size).to eq(0)
      expect(cache.has?('a')).to be false
    end

    it 'CachedStemmer exposes clear_cache!' do
      expect(stemmer).to respond_to(:clear_cache!)
      stemmer.stem('memakan')
      stemmer.clear_cache!
      # After clearing, cache should be empty
      expect(stemmer.cache.size).to eq(0)
    end

    it 'data returns a copy (not the internal hash)' do
      cache = Sastrawi::Stemmer::Cache::ArrayCache.new
      cache.set('a', 1)

      external = cache.data
      external[:b] = 2

      expect(cache.has?('b')).to be false
    end
  end
end
