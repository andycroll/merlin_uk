require_relative 'live_helper'

# Every venue's home page: 22 requests.
class LivePageShapeTest < Minitest::Test
  include PageShapes

  def test_pages_are_readable
    website = MerlinUk::Internal::Website.new
    MerlinUk::Cinema.all.each do |cinema|
      assert_page_shape(website.home(cinema.url))
    end
  end
end
