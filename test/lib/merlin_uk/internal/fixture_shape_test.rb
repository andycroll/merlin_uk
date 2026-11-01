require_relative '../../../test_helper'

class FixtureShapeTest < Minitest::Test
  include PageShapes
  include FixturesHelper

  def test_venue_fixtures_match_shape
    %w(MER_REDR MER_GALA).each { |code| assert_page_shape(venue_html(code)) }
  end
end
