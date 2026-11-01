require_relative '../../../../test_helper'

class MerlinUk::Internal::Parser::ScheduleTest < Minitest::Test
  include FixturesHelper

  def test_reads_every_film_card_once
    showings = showings_in(venue_html('MER_REDR'))

    assert_equal 16, showings.count
    assert_equal showings.map(&:booking_url).uniq, showings.map(&:booking_url)
  end

  def test_live_stage_shows_are_not_films
    titles = showings_in(venue_html('MER_REDR')).map(&:title).uniq

    refute_includes titles, 'Jack and the Beanstalk presented by RAMPS'
  end

  def test_yearless_dates_take_the_nearest_year
    html = page('2027-01-02', 'Thursday 31st December')

    assert_equal Time.utc(2026, 12, 31, 18), showings_in(html).first.starting_at
  end

  def test_dates_with_years_keep_them
    html = page('2026-11-01', 'Friday 1st January 2027')

    assert_equal Time.utc(2027, 1, 1, 18), showings_in(html).first.starting_at
  end

  def test_links_need_a_date_and_a_time
    html = page('2026-11-01', 'Coming soon') + page('2026-11-01', 'Monday 2nd November', time: 'Sold out')

    assert_empty showings_in(html)
  end

  def test_page_without_full_schedule_is_an_error
    assert_raises(RuntimeError) { showings_in('<html></html>') }
  end

  def test_yearless_dates_need_a_listed_day
    html = page('2026-11-01', 'Monday 2nd November').sub(/<li data-date="\d[^>]*>/, '')

    assert_raises(RuntimeError) { showings_in(html) }
  end

  private

  def showings_in(html)
    MerlinUk::Internal::Parser::Schedule.new(html).showings
  end

  def page(first_day, heading, time: '18:00')
    <<~HTML
      <ul><li data-date="full">All Films</li><li data-date="#{first_day}">Today</li></ul>
      <div data-frame="full">
        <div class="filmCard full" data-film="1-film"><h2 class="overlay">Film</h2>
          <h5>#{heading}</h5>
          <a href="https://merlinredruth.admit-one.eu/?p=tickets&amp;perfCode=1" class="mealdeal">#{time}</a>
        </div>
      </div>
    HTML
  end
end
