# frozen_string_literal: true

module MerlinUk
  # Internal utility classes: Do not use
  # @api private
  module Internal
    # Reads venue pages from merlincinemas.co.uk. Each venue has its own
    # subdomain, whose home page holds every advertised date in its full
    # schedule.
    class Website
      include Http

      # @param [String] venue_url e.g. 'https://redruth.merlincinemas.co.uk'
      # @return [String] the venue's home page
      def home(venue_url)
        get("#{venue_url}/")
      end
    end
  end
end
