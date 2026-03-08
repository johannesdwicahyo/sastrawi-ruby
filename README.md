# sastrawi-ruby

Indonesian language stemmer for Ruby. Stems words in Bahasa Indonesia using the Nazief & Adriani algorithm with Enhanced Confix Stripping (ECS).

This is an actively maintained fork of [meisyal/sastrawi-ruby](https://github.com/meisyal/sastrawi-ruby).

## What's New in v0.2.0

- **Bug fixes**: Fixed 3 stemming bugs (`menerangi`, `berimanlah`, `kesepersepuluhnya`)
- **Dictionary**: Added missing words (`sepuluh`)
- **Modernized**: Ruby 3.0+ required, updated dependencies, GitHub Actions CI
- **Fixed regex warning** in disambiguator prefix rule 16

## Installation

```ruby
# Gemfile
gem "sastrawi"
```

```bash
gem install sastrawi
```

Requires Ruby 3.0+.

## Usage

### Stemming

```ruby
require "sastrawi"

factory = Sastrawi::Stemmer::StemmerFactory.new
stemmer = factory.create_stemmer

stemmer.stem("Perekonomian Indonesia sedang dalam pertumbuhan yang membanggakan")
# => "ekonomi indonesia sedang dalam tumbuh yang bangga"

stemmer.stem("membangunkan")  # => "bangun"
stemmer.stem("bersembunyi")   # => "sembunyi"
stemmer.stem("menerangi")     # => "terang"
stemmer.stem("kesepersepuluhnya") # => "sepuluh"
```

### Stop Word Removal

```ruby
require "sastrawi"

factory = Sastrawi::StopWordRemover::StopWordRemoverFactory.new
stop_words = factory.get_stop_word
# => ["a", "ada", "adalah", "agar", "akan", ...]
```

### Custom Dictionary

```ruby
require "sastrawi"

factory = Sastrawi::Stemmer::StemmerFactory.new
dictionary = factory.create_default_dictionary

# Add words from file
dictionary.add_words_from_text_file("my-dictionary.txt")

# Add/remove individual words
dictionary.add("internet")
dictionary.remove("desa")

stemmer = Sastrawi::Stemmer::Stemmer.new(dictionary)
stemmer.stem("internetan")  # => "internet"
```

## How It Works

Indonesian stemming removes affixes (prefixes, suffixes, infixes) to find base words:

| Affix Type | Examples | Algorithm Step |
|---|---|---|
| Inflectional Particle | -lah, -kah, -pun | Removed first |
| Possessive Pronoun | -ku, -mu, -nya | Removed second |
| Derivational Suffix | -i, -kan, -an | Removed third |
| Derivational Prefix | me-, ber-, ter-, pe-, di-, ke-, se- | Removed last (up to 3 layers) |

The algorithm uses Confix Stripping (CS) and Enhanced Confix Stripping (ECS) for handling complex prefix-suffix combinations, plus a dictionary lookup at each step to validate results.

## Known Limitations

- `memuaskan` stems to `muas` instead of `puas` — both are valid dictionary words and the algorithm picks the first match (Rule13a). This is an inherent ambiguity in the Nazief-Adriani algorithm.

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/johannesdwicahyo/sastrawi-ruby).

## License

MIT License. Contains base words from [Kateglo](https://kateglo.com) licensed under [CC BY-NC-SA 3.0](https://creativecommons.org/licenses/by-nc-sa/3.0/).

## Credits

- Original PHP implementation: [sastrawi/sastrawi](https://github.com/sastrawi/sastrawi)
- Ruby port: [Andrias Meisyal](https://github.com/meisyal)
- Fork maintainer: [Johannes Dwi Cahyo](https://github.com/johannesdwicahyo)
