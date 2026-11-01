module MerlinUk
  # The object representing a cinema on the Merlin Cinemas website
  class Cinema < Cinebase::Cinema
    # @!attribute [r] id
    #   @return [String] the website's cinema code, e.g. 'MER_REDR'

    # The website lists its venues and codes in a menu but gives addresses
    # only on each venue's information page, and no coordinates, so the gem
    # holds them: names and codes from the menu, addresses from the
    # information pages, coordinates from OpenStreetMap or, where it has no
    # venue, the postcode.
    VENUES = {
      'MER_BODM' => {
        name: 'Capitol Cinema, Bodmin', subdomain: 'bodmin', street_address: 'Mount Folly Square',
        locality: 'Bodmin', region: 'Cornwall', postal_code: 'PL31 2DB', latitude: 50.470563, longitude: -4.719178
      },
      'MER_HELS' => {
        name: 'Flora Cinema, Helston', subdomain: 'helston', street_address: '17 Wendron Street',
        locality: 'Helston', region: 'Cornwall', postal_code: 'TR13 8PT', latitude: 50.101288, longitude: -5.273108
      },
      'MER_FALM' => {
        name: 'Phoenix Cinema, Falmouth', subdomain: 'falmouth', street_address: '11 Berkeley Vale',
        locality: 'Falmouth', region: 'Cornwall', postal_code: 'TR11 3PL', latitude: 50.15405, longitude: -5.074337
      },
      'MER_REDR' => {
        name: 'Regal Cinema & Theatre, Redruth', subdomain: 'redruth', street_address: 'Fore Street',
        locality: 'Redruth', region: 'Cornwall', postal_code: 'TR15 2AZ', latitude: 50.233212, longitude: -5.229744
      },
      'MER_STIV' => {
        name: 'Royal Cinema, St. Ives', subdomain: 'st-ives', street_address: 'Royal Square',
        locality: 'St Ives', region: 'Cornwall', postal_code: 'TR26 2ND', latitude: 50.211081, longitude: -5.481897
      },
      'MER_PENZ' => {
        name: 'Savoy Cinema, Penzance', subdomain: 'penzance', street_address: '16 Causewayhead',
        locality: 'Penzance', region: 'Cornwall', postal_code: 'TR18 2SN', latitude: 50.119726, longitude: -5.538722
      },
      'MER_RITZ' => {
        name: 'The Ritz, Penzance', subdomain: 'ritz', street_address: '4 Queen Street',
        locality: 'Penzance', region: 'Cornwall', postal_code: 'TR18 4BJ', latitude: 50.117616, longitude: -5.536687
      },
      'MER_ILFR' => {
        name: 'Embassy Cinema, Ilfracombe', subdomain: 'ilfracombe', street_address: '134 High Street',
        locality: 'Ilfracombe', region: 'Devon', postal_code: 'EX34 9EZ', latitude: 51.208405, longitude: -4.121911
      },
      'MER_KING' => {
        name: 'Kings Cinema, Kingsbridge', subdomain: 'kingsbridge', street_address: 'Fore Street',
        locality: 'Kingsbridge', region: 'Devon', postal_code: 'TQ7 1PP', latitude: 50.285613, longitude: -3.778093
      },
      'MER_OKEH' => {
        name: 'New Carlton Cinema, Okehampton', subdomain: 'okehampton', street_address: 'Market Street',
        locality: 'Okehampton', region: 'Devon', postal_code: 'EX20 1HN', latitude: 50.739349, longitude: -4.003581
      },
      'MER_TORQ' => {
        name: 'New Central Cinema, Torquay', subdomain: 'torquay', street_address: '90-96 Union Street',
        locality: 'Torquay', region: 'Devon', postal_code: 'TQ2 5PY', latitude: 50.467185, longitude: -3.530679
      },
      'MER_TIVE' => {
        name: 'Tivoli Cinema, Tiverton', subdomain: 'tiverton', street_address: '23 Fore Street',
        locality: 'Tiverton', region: 'Devon', postal_code: 'EX16 6LD', latitude: 50.902181, longitude: -3.486483
      },
      'MER_COLE' => {
        name: 'Studio Cinema, Coleford', subdomain: 'coleford', street_address: '14 High Street',
        locality: 'Coleford', region: 'Gloucestershire', postal_code: 'GL16 8HF',
        latitude: 51.792524, longitude: -2.617573
      },
      'MER_CROM' => {
        name: 'Regal Movieplex, Cromer', subdomain: 'cromer', street_address: '2-4 Hans Place',
        locality: 'Cromer', region: 'Norfolk', postal_code: 'NR27 9EQ', latitude: 52.930769, longitude: 1.300493
      },
      'MER_REDC' => {
        name: 'The Regent, Redcar', subdomain: 'redcar', street_address: 'Newcomen Terrace',
        locality: 'Redcar', region: 'North Yorkshire', postal_code: 'TS10 1AU', latitude: 54.62059, longitude: -1.07025
      },
      'MER_WEST' => {
        name: 'Plaza Cinema, Weston-super-Mare', subdomain: 'wsm', street_address: 'Walliscote Road',
        locality: 'Weston-super-Mare', region: 'Somerset', postal_code: 'BS23 1US',
        latitude: 51.346664, longitude: -2.975809
      },
      'MER_WELL' => {
        name: 'Wellesley Cinema, Wellington', subdomain: 'wellington', street_address: 'Mantle Street',
        locality: 'Wellington', region: 'Somerset', postal_code: 'TA21 8AU', latitude: 50.975938, longitude: -3.231092
      },
      'MER_AYRS' => {
        name: 'Astoria Cinema, Ayr', subdomain: 'ayr', street_address: 'Burns Statue Square',
        locality: 'Ayr', region: 'Ayrshire', postal_code: 'KA7 1UP', latitude: 55.457617, longitude: -4.628246
      },
      'MER_THUR' => {
        name: 'Merlin Cinema, Thurso', subdomain: 'thurso', street_address: 'Ormlie Road',
        locality: 'Thurso', region: 'Caithness', postal_code: 'KW14 7QU', latitude: 58.5863, longitude: -3.536282
      },
      'MER_GALA' => {
        name: 'Pavilion Cinema, Galashiels', subdomain: 'galashiels', street_address: 'Market Street',
        locality: 'Galashiels', region: 'Scottish Borders', postal_code: 'TD1 3AF',
        latitude: 55.61554, longitude: -2.805527
      },
      'MER_PRES' => {
        name: 'Scala Cinema, Prestatyn', subdomain: 'prestatyn', street_address: '47 High Street',
        locality: 'Prestatyn', region: 'Denbighshire', postal_code: 'LL19 9AH', latitude: 53.33545, longitude: -3.404633
      },
      'MER_RHYL' => {
        name: 'Strand Cinema, Rhyl', subdomain: 'rhyl', street_address: 'West Parade', extended_address: 'The Village',
        locality: 'Rhyl', region: 'Denbighshire', postal_code: 'LL18 1HB', latitude: 53.322014, longitude: -3.492144
      }
    }.freeze

    ADDRESS_PARTS = %i(street_address extended_address locality region postal_code).freeze

    # Constructor
    # @param [String] id the website's cinema code, e.g. 'MER_REDR' or 'mer_redr'
    # @return [MerlinUk::Cinema]
    def initialize(id)
      @id = id.to_s.upcase
    end

    # Return basic cinema information for all cinemas
    # @return [Array<MerlinUk::Cinema>]
    # @example
    #   MerlinUk::Cinema.all
    #   #=> [<MerlinUk::Cinema>, <MerlinUk::Cinema>, ...]
    def self.all
      VENUES.keys.map { |id| new(id) }
    end

    # @!method address
    #   Address of the cinema
    #   @return [Hash] of different address parts
    #   @see #adr

    # Address of the cinema
    # @return [Hash] contains :street_address, :extended_address,
    # :locality, :region, :postal_code, :country_name
    # @example
    #   cinema = MerlinUk::Cinema.new('MER_RHYL')
    #   cinema.adr
    #   #=> {
    #         street_address:   'West Parade',
    #         extended_address: 'The Village',
    #         locality:         'Rhyl',
    #         region:           'Denbighshire',
    #         postal_code:      'LL18 1HB',
    #         country_name:     'United Kingdom'
    #       }
    # @note Uses method naming as at http://microformats.org/wiki/adr
    def adr
      ADDRESS_PARTS.to_h { |part| [part, venue[part]] }.merge(country_name: 'United Kingdom')
    end

    # Brand of the cinema
    # @return [String] which will always be 'Merlin'
    def brand
      'Merlin'.freeze
    end

    # @return [Float, nil]
    def latitude
      venue[:latitude]
    end

    # @return [Float, nil]
    def longitude
      venue[:longitude]
    end

    # The name of the cinema
    # @return [String]
    # @example
    #   MerlinUk::Cinema.new('MER_REDR').name
    #   #=> 'Regal Cinema & Theatre, Redruth'
    def name
      venue[:name].to_s
    end

    # The url of the cinema's pages on the Merlin Cinemas website
    # @return [String]
    # @example
    #   MerlinUk::Cinema.new('MER_REDR').url
    #   #=> 'https://redruth.merlincinemas.co.uk'
    def url
      subdomain = venue[:subdomain]
      subdomain ? "https://#{subdomain}.merlincinemas.co.uk" : ''
    end

    private

    def venue
      VENUES.fetch(id, {})
    end
  end
end
