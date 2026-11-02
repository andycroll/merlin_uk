require_relative '../../../test_helper'

class MerlinUk::Internal::WebsiteTest < Minitest::Test
  include PageStubs

  VENUE = 'https://redruth.merlincinemas.co.uk'.freeze

  def test_home_reads_a_venue_home_page
    stub_pages

    assert_includes MerlinUk::Internal::Website.new.home(VENUE), 'data-frame="full"'
  end

  def test_errors_name_the_status_but_not_the_body
    stub_request(:get, REDRUTH).to_return(status: 500, body: 'secret')

    error = assert_raises(RuntimeError) { MerlinUk::Internal::Website.new.home(VENUE) }
    assert_equal 'HTTP error 500 from redruth.merlincinemas.co.uk', error.message
  end

  def test_transient_errors_are_retried
    stub_request(:get, REDRUTH).to_raise(Errno::ECONNRESET).then.to_return(status: 200, body: venue_html('MER_REDR'))

    Cinebase::Http.stub(:pause, nil) { MerlinUk::Internal::Website.new.home(VENUE) }

    assert_requested :get, REDRUTH, times: 2
  end
end
