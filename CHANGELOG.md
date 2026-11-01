# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [1.0.0] - 2026-11-01

### Added
- `MerlinUk::Cinema.all` and `MerlinUk::Cinema.new(id)` for Merlin Cinemas' 22 venues, keyed by the website's cinema code, with names and codes from the website's cinema menu, addresses from each venue's information page and coordinates from OpenStreetMap or the postcode.
- `MerlinUk::Performance.at(id, from:, to:)`, from the full schedule on the venue's home page, which holds every advertised date, with Admit One booking links, variants from booking link icons, event cinema markers and titles, and film years from titles. Live stage shows are left out.
- Fixtures trimmed from live pages, a live shape test that checks real pages without storing them, and GitHub Actions CI and release workflows.
