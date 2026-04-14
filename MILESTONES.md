# sastrawi-ruby — Milestones

> **Source of truth:** https://github.com/johannesdwicahyo/sastrawi-ruby/milestones
> **Last synced:** 2026-04-14

This file mirrors the GitHub milestones for this repo. Edit the milestone or issues on GitHub and re-sync, do not hand-edit.

## v1.0.0 — Production Ready (**open**)

_Stable API, thread safety, comprehensive docs, ecosystem integration_

- [ ] #18 Thread safety audit
- [ ] #19 YARD documentation for all public methods
- [ ] #20 Integration with pattern-ruby and tokenizer-ruby
- [ ] #21 CI pipeline for Ruby 3.0-3.4 with coverage
- [ ] #22 Stable API freeze and deprecation policy
- [ ] #23 Rails integration helper

## v0.5.0 — Modern Indonesian & Slang (**open**)

_Internet slang, informal language, loan words, abbreviation handling_

- [ ] #13 Indonesian internet slang normalization
- [ ] #14 Loan word handling (English, Arabic, Dutch)
- [ ] #15 Informal prefix/suffix handling
- [ ] #16 Named entity preservation
- [ ] #17 Custom stemming rules DSL

## v0.4.0 — Performance & API (**open**)

_Caching improvements, batch stemming, simplified API, benchmarks_

- [ ] #7 LRU cache with configurable size limit
- [ ] #8 Batch stemming API with parallel processing
- [ ] #9 Simplified top-level API
- [ ] #10 Performance benchmark suite
- [ ] #11 Lazy dictionary loading
- [ ] #12 Stemmer#stem_word for single word without sentence splitting

## v0.3.0 — Dictionary & Stemming Accuracy (**closed**)

_Expand dictionary, fix ambiguous stems, improve stemming accuracy for modern Indonesian_

- [x] #1 Fix memuaskan ambiguity (stems to muas instead of puas)
- [x] #2 Audit dictionary for missing common words
- [x] #3 Gold standard accuracy test suite (500+ word pairs)
- [x] #4 Handle reduplicated words (partial and rhyming)
- [x] #5 Expand stop word list and move to data file
- [x] #6 Add frozen_string_literal to all source files
