# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [1.1.0] - 2026-11-03

### Changed
- Uses cinebase 5.9: performances take the raw `title:`, so audience labels become variants, and series prefixes such as `Met Opera:` become the performance's `event`.

## [1.0.1] - 2026-11-02

### Changed
- Requests and London times use cinebase 5.8's `Cinebase::Http` and `Cinebase::London`.
- HTTP errors read "HTTP error 500 from redruth.merlincinemas.co.uk" rather than "Merlin Cinemas HTTP error 500".

## [1.0.0] - 2026-11-01

### Added
- `MerlinUk::Cinema.all` and `MerlinUk::Cinema.new(id)` for Merlin Cinemas' 22 venues, keyed by the website's cinema code, with names and codes from the website's cinema menu, addresses from each venue's information page and coordinates from OpenStreetMap or the postcode.
- `MerlinUk::Performance.at(id, from:, to:)`, from the full schedule on the venue's home page, which holds every advertised date, with Admit One booking links, variants from booking link icons, event cinema markers and titles, and film years from titles. Live stage shows are left out.
- Fixtures trimmed from live pages, a live shape test that checks real pages without storing them, and GitHub Actions CI and release workflows.
