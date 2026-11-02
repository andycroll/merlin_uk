# frozen_string_literal: true

module MerlinUk
  # @api private
  module Internal
    module Parser
      # Reads the full schedule on a venue's home page: a card for each film,
      # each with dated rows of booking links. The page also repeats the
      # schedule day by day, which this ignores.
      class Schedule
        FULL = /<div data-frame="full">(.*?)(?:<div data-frame="\d|\z)/m
        CARD = /<div class="filmCard full" data-film="[^"]*">/
        TITLE = %r{<h2 class="overlay">([^<]*)</h2>}
        LISTING_ICON = %r{<img src="/images/(\w+)\.png" class="live_theatre"}
        DATE_OR_LINK = %r{<h5>([^<]*)</h5>|<a href="([^"]*perfCode=\d+[^"]*)"[^>]*>(.*?)</a>}m
        KEY = /data-key="([^"]+)"/
        TIME = /(\d{1,2}):(\d{2})/
        DATE = /(\d{1,2})(?:st|nd|rd|th) (#{Date::MONTHNAMES.compact.join('|')})(?: (\d{4}))?/
        FIRST_DAY = /<li data-date="(\d{4}-\d{2}-\d{2})"/

        # The site marks live stage shows, which are not films, with this
        # icon, and screened theatre, opera and concerts with 'event_cinema'
        STAGE_ICON = 'theatre'

        # @param [String] html a venue's home page
        def initialize(html)
          @html = html
        end

        # Every screening in the full schedule, leaving out live stage shows.
        # Each once, as featured films also appear again in the list.
        # @return [Array<MerlinUk::Internal::Parser::Showing>]
        # @raise [RuntimeError] when the page has no full schedule
        def showings
          full = @html[FULL, 1]
          if full
            all = full.split(CARD).drop(1).flat_map do |card|
              icon = card[LISTING_ICON, 1]
              icon == STAGE_ICON ? [] : card_showings(card, icon)
            end
            all.uniq(&:booking_url)
          else
            raise 'Merlin Cinemas page has no full schedule'
          end
        end

        private

        def card_showings(card, icon)
          title = CGI.unescapeHTML(card[TITLE, 1].to_s).strip
          date = nil
          card.scan(DATE_OR_LINK).filter_map do |heading, href, link|
            if heading
              date = parse_date(heading)
              nil
            elsif date && (time = link.match(TIME))
              Showing.new(title: title, event_cinema: !icon.nil?, starting_at: starting_at(date, time),
                          booking_url: CGI.unescapeHTML(href), keys: link.scan(KEY).flatten.uniq)
            end
          end
        end

        # The site gives the year only for dates outside its current year
        def parse_date(heading)
          match = heading.match(DATE)
          if match
            day = match[1].to_i
            month = Date::MONTHNAMES.index(match[2])
            if match[3]
              Date.new(match[3].to_i, month, day)
            else
              nearest_date(day, month)
            end
          end
        end

        def nearest_date(day, month)
          years = (first_day.year - 1)..(first_day.year + 1)
          dates = years.filter_map { |year| Date.new(year, month, day) if Date.valid_date?(year, month, day) }
          dates.min_by { |date| (date - first_day).abs }
        end

        def first_day
          @first_day ||= begin
            iso = @html[FIRST_DAY, 1]
            if iso
              Date.iso8601(iso)
            else
              raise 'Merlin Cinemas page lists no days'
            end
          end
        end

        def starting_at(date, time)
          Cinebase::London.utc(Time.utc(date.year, date.month, date.day, time[1].to_i, time[2].to_i))
        end
      end
    end
  end
end
