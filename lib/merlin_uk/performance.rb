module MerlinUk
  # A single screening of a film on the Merlin Cinemas website
  class Performance < Cinebase::Performance
    # @!attribute [r] booking_url
    #   @return [String] the booking URL on the venue's Admit One site
    # @!attribute [r] cinema_name
    #   @return [String] the cinema name
    # @!attribute [r] cinema_id
    #   @return [String] the cinema id
    # @!attribute [r] dimension
    #   @return [String] 2d or 3d
    # @!attribute [r] film_name
    #   @return [String] the film name

    # @!method initialize(options)
    #   @param [Hash] options options hash
    #   @option options [String] :booking_url (nil) buying url for the screening
    #   @option options [String] :cinema_name name of the cinema
    #   @option options [String] :cinema_id website id of the cinema
    #   @option options [String] :dimension ('2d') dimension of the screening
    #   @option options [Cinebase::Festival] :festival (nil) festival edition
    #   @option options [String] :film_name name of the film
    #   @option options [Integer] :film_year (nil) year from the film's title
    #   @option options [String] :language (nil) audio language, e.g. 'Hindi'
    #   @option options [Time] :starting_at listed start time of the performance

    TIME_ZONE = 'Europe/London'.freeze

    # Performances within an inclusive range of showing dates, from one
    # request: the venue's home page holds every advertised date.
    # @param [String] cinema_id the website's cinema code, e.g. 'MER_REDR'
    # @param [Date] from first date (defaults to today in London)
    # @param [Date] to last date (defaults to 13 days after from)
    # @return [Array<MerlinUk::Performance>]
    def self.at(
      cinema_id,
      from: TZInfo::Timezone.get(TIME_ZONE).now.to_date,
      to: from + 13
    )
      raise ArgumentError, 'to must not precede from' if to < from

      cinema = Cinema.new(cinema_id)
      if cinema.url.empty?
        []
      else
        html = MerlinUk::Internal::Website.new.home(cinema.url)
        showings = MerlinUk::Internal::Parser::Schedule.new(html).showings
        performances = showings.select { |showing| (from..to).cover?(london_date(showing.starting_at)) }.map do |showing|
          new(showing.to_hash.merge(cinema_id: cinema.id, cinema_name: cinema.name))
        end
        performances.sort_by(&:starting_at)
      end
    end

    # @!method showing_on
    #   The date of the screening
    #   @return [Date]

    # @!method starting_at
    #   UTC time of the screening
    #   @return [Time]

    # @!method variant
    #   The kinds of screening (arts, baby, q&a, relaxed, subtitled)
    #   @return <Array[String]>

    def self.london_date(time)
      TZInfo::Timezone.get(TIME_ZONE).to_local(time).to_date
    end
    private_class_method :london_date
  end
end
