# frozen_string_literal: true

module MerlinUk
  # @api private
  module Internal
    module Parser
      # One screening from a venue's full schedule
      class Showing
        # Booking link icons and the variants they mean. Others, such as
        # 'access', 'licensed', 'luxury', 'box' (private boxes) and 'saver'
        # (cheap tickets), are not variants.
        KEYS = {
          'autism' => 'relaxed',
          'baby' => 'baby',
          'subtitled' => 'subtitled'
        }.freeze

        TITLES = {
          /\ABring Your Own Baby\b/i => 'baby',
          /\bQ&A\b/i => 'q&a'
        }.freeze

        THREE_D = /\b3D\b/i
        LANGUAGE = /\((#{Cinebase::TitleSanitizer::LANGUAGES.join('|')})\)/i

        # @return [String] the film's title as listed
        attr_reader :title
        # @return [Time] UTC start
        attr_reader :starting_at
        # @return [String] the venue's Admit One booking page
        attr_reader :booking_url

        # @param [String] title the film's title as listed
        # @param [Boolean] event_cinema whether the site marks the film as
        #   event cinema: screened theatre, opera, ballet, concerts or art
        # @param [Time] starting_at UTC start
        # @param [String] booking_url the venue's Admit One booking page
        # @param [Array<String>] keys the booking link's icons, e.g. 'subtitled'
        def initialize(title:, event_cinema:, starting_at:, booking_url:, keys:)
          @title = title
          @event_cinema = event_cinema
          @starting_at = starting_at
          @booking_url = booking_url
          @keys = keys
        end

        # @return [Hash] options for MerlinUk::Performance.new
        def to_hash
          {
            booking_url: @booking_url,
            dimension: @title.match?(THREE_D) ? '3d' : '2d',
            festival: Cinebase::Festival.from_title(@title, year: @starting_at.year),
            film_name: TitleSanitizer.new(@title).sanitized,
            film_year: Cinebase::TitleSanitizer.film_year(@title),
            language: @title[LANGUAGE, 1],
            starting_at: @starting_at,
            title: @title,
            variant: variant
          }
        end

        private

        def variant
          from_titles = TITLES.filter_map { |pattern, variant| variant if @title.match?(pattern) }
          from_keys = @keys.filter_map { |key| KEYS[key] }
          (from_keys + from_titles + (@event_cinema ? ['arts'] : [])).uniq
        end
      end
    end
  end
end
