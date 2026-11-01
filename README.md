# MerlinUk

A simple gem to pull cinemas and performances from the [Merlin Cinemas website](https://www.merlincinemas.co.uk) and spit out useful formatted info.

## Installation

Add this line to your application's Gemfile:

    gem 'merlin_uk'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install merlin_uk

## Usage

The gem conforms to the API set down in the `cinebase` gem, [andycroll/cinebase](https://github.com/andycroll/cinebase), which provides a lot of useful base vocabulary and repetitive code for this series of cinema focussed gems.

Performance titles are sanitized as much as possible, removing years, the
Bring Your Own Baby prefix, film society and special screening prefixes, Q&A
and "at The Ritz" suffixes, and naming National Theatre Live, Royal Ballet
and Opera and Met Opera screenings in full.

No token or setup is needed. The website has no API: each venue's home
page lists its whole schedule in HTML. Tickets are sold through each venue's
Admit One site.

### Cinema

The website lists its venues and cinema codes in a menu but gives addresses
only on each venue's information page, and no coordinates, so the gem holds
them: names and codes from the menu, addresses from the information pages,
and coordinates from OpenStreetMap or, for the Ritz in Penzance, the New
Central in Torquay and the Strand in Rhyl, which it does not map, the
postcode. Cinema methods make no requests.

``` ruby
MerlinUk::Cinema.all
#=> [<MerlinUk::Cinema ...>, <MerlinUk::Cinema ...>, ...]

cinema = MerlinUk::Cinema.new('MER_REDR')
#=> <MerlinUk::Cinema ...>

cinema.adr
#=> {
  street_address:   'Fore Street',
  extended_address: nil,
  locality:         'Redruth',
  region:           'Cornwall',
  postal_code:      'TR15 2AZ',
  country_name:     'United Kingdom'
}

cinema.brand
#=> 'Merlin'

cinema.name
#=> 'Regal Cinema & Theatre, Redruth'

cinema.full_name
#=> 'Merlin Regal Cinema & Theatre, Redruth'

cinema.id
#=> 'MER_REDR'

cinema.latitude
#=> 50.233212

cinema.url
#=> 'https://redruth.merlincinemas.co.uk'
```

### Performances

`Performance.at` returns performances for an inclusive range of showing dates,
defaulting to today in London and the following 13 days. The venue's home
page holds every advertised date, so any range is one request.

``` ruby
MerlinUk::Performance.at('MER_REDR', from: Date.today, to: Date.today + 2)
#=> [<MerlinUk::Performance ...>, <MerlinUk::Performance ...>, ...]

performance = MerlinUk::Performance.at('MER_REDR').first
#=> <MerlinUk::Performance ...>

performance.film_name
#=> 'No Trees No Seas' # from 'No Trees No Seas with Q&A'

performance.film_year
#=> nil # from the title, e.g. 1960 for 'Picture House presents Psycho (1960)'

performance.dimension
#=> '2d'

performance.variant
#=> ['q&a']

performance.subtitled?
#=> false

performance.starting_at
#=> 2026-11-12 19:30:00 UTC

performance.booking_url
#=> 'https://merlinredruth.admit-one.eu/?p=tickets&perfCode=93005'

performance.cinema_name
#=> 'Regal Cinema & Theatre, Redruth'

performance.cinema_id
#=> 'MER_REDR'
```

Booking links are the website's own, to the venue's Admit One site, which
redirects to seat selection.

Variants come from each booking link's icons, the website's event cinema
marker and titles: `arts` (event cinema: theatre, opera, ballet, concerts
and art), `baby` (Bring Your Own Baby), `q&a`, `relaxed` (autism friendly)
and `subtitled`. Super Saver prices, luxury seats, private boxes and
licensed screenings are not variants.

Live stage shows, which the website marks with a theatre icon, are not
films and are left out. Mostly these are at the Regal in Redruth and the
Ritz in Penzance.

## Tests

```sh
bundle exec rake          # unit tests against fixtures
bundle exec rake live     # live merlincinemas.co.uk
```

The fixtures in `test/fixtures` are the Redruth and Galashiels home pages,
trimmed to a few films without the page's head and navigation.
`test/support/page_shapes.rb` describes the markup the gem reads. The unit
suite checks the fixtures against it and the live suite checks every
venue's real page, held only in memory. When the website changes, update
the shape first, then the fixtures.

## Releasing

Bump the version, merge, then run the **Release Gem** workflow in GitHub
Actions. It runs the tests, tags the version and publishes the gem through
RubyGems trusted publishing.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
