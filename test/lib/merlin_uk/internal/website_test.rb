require_relative '../../../test_helper'

class MerlinUk::Internal::WebsiteTest < Minitest::Test
  include PageStubs

  VENUE = 'https://redruth.merlincinemas.co.uk'.freeze

  def test_home_reads_a_venue_home_page
    stub_pages

    assert_includes MerlinUk::Internal::Website.new.home(VENUE), 'data-frame="full"'
  end

  def test_pages_are_utf8
    stub_pages

    assert_equal Encoding::UTF_8, MerlinUk::Internal::Website.new.home(VENUE).encoding
  end

  def test_errors_name_the_status_but_not_the_body
    stub_request(:get, REDRUTH).to_return(status: 500, body: 'secret')

    error = assert_raises(RuntimeError) { MerlinUk::Internal::Website.new.home(VENUE) }
    assert_equal 'Merlin Cinemas HTTP error 500', error.message
  end

  def test_redirects_are_not_followed
    stub_request(:get, REDRUTH).to_return(status: 302, headers: { 'Location' => 'https://www.merlincinemas.co.uk/' })

    assert_raises(RuntimeError) { MerlinUk::Internal::Website.new.home(VENUE) }
  end

  def test_transient_errors_are_retried
    stub_request(:get, REDRUTH).to_raise(Errno::ECONNRESET).then.to_return(status: 200, body: venue_html('MER_REDR'))
    website = MerlinUk::Internal::Website.new

    website.stub(:sleep, nil) { website.home(VENUE) }

    assert_requested :get, REDRUTH, times: 2
  end

  def test_retries_give_up
    stub_request(:get, REDRUTH).to_raise(Net::OpenTimeout)
    website = MerlinUk::Internal::Website.new

    assert_raises(Net::OpenTimeout) { website.stub(:sleep, nil) { website.home(VENUE) } }
    assert_requested :get, REDRUTH, times: 3
  end
end
