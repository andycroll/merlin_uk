require_relative 'fixtures_helper'

# Serve the fixtures in place of venue home pages
module PageStubs
  include FixturesHelper

  REDRUTH = 'https://redruth.merlincinemas.co.uk/'.freeze
  GALASHIELS = 'https://galashiels.merlincinemas.co.uk/'.freeze

  private

  def stub_pages
    stub_request(:get, REDRUTH).to_return(status: 200, body: venue_html('MER_REDR'))
    stub_request(:get, GALASHIELS).to_return(status: 200, body: venue_html('MER_GALA'))
  end
end
