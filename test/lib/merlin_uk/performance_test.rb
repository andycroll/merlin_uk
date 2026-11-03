require_relative '../../test_helper'

class MerlinUk::PerformanceTest < Minitest::Test
  include PageStubs

  DATE = Date.new(2026, 11, 3)
  BOOKING = 'https://merlinredruth.admit-one.eu/?p=tickets&perfCode='.freeze

  def setup
    stub_pages
  end

  def test_at_returns_performances_in_time_order
    performances = performances_at('MER_REDR')

    assert(performances.all? { |p| p.instance_of?(MerlinUk::Performance) })
    assert_equal 16, performances.count
    assert_equal performances.map(&:starting_at).sort, performances.map(&:starting_at)
  end

  def test_at_reads_every_date_from_one_request
    performances_at('mer_redr')

    assert_requested :get, REDRUTH, times: 1
  end

  def test_at_keeps_to_the_range
    performances = MerlinUk::Performance.at('MER_REDR', from: DATE, to: DATE)

    assert_equal 3, performances.count
    assert_equal [DATE], performances.map(&:showing_on).uniq
  end

  def test_at_sets_cinema_details
    performances = performances_at('MER_REDR')

    assert_equal ['MER_REDR'], performances.map(&:cinema_id).uniq
    assert_equal ['Regal Cinema & Theatre, Redruth'], performances.map(&:cinema_name).uniq
  end

  def test_at_parses_first_performance
    performance = performances_at('MER_REDR').first

    assert_equal 'Wicker', performance.film_name
    assert_nil performance.film_year
    assert_equal Time.utc(2026, 11, 1, 19, 30), performance.starting_at
    assert_equal '2d', performance.dimension
    assert_empty performance.variant
    assert_equal "#{BOOKING}93171", performance.booking_url
  end

  def test_summer_times_are_converted_to_utc
    performance = performances_at('MER_REDR').last

    assert_equal 'Romeo & Juliet', performance.film_name
    assert_equal Cinebase::Event.new(name: 'Royal Ballet and Opera'), performance.event
    assert_equal Time.utc(2027, 5, 25, 18, 15), performance.starting_at
    assert_equal %w(arts), performance.variant
  end

  def test_subtitled_screenings
    performance = find('MER_REDR', '93203')

    assert_equal %w(subtitled), performance.variant
    assert performance.subtitled?
  end

  def test_q_and_a_screenings
    performance = find('MER_REDR', '93005')

    assert_equal 'No Trees No Seas', performance.film_name
    assert_equal %w(q&a), performance.variant
  end

  def test_parent_and_baby_screenings
    performance = find('MER_GALA', '8053')

    assert_equal 'The Summer Book', performance.film_name
    assert_equal %w(baby), performance.variant
    assert_equal 'Pavilion Cinema, Galashiels', performance.cinema_name
  end

  def test_unknown_cinema_makes_no_request
    assert_empty MerlinUk::Performance.at('MER_ZZZZ', from: DATE, to: DATE)
    assert_not_requested :get, /merlincinemas/
  end

  def test_to_must_not_precede_from
    assert_raises(ArgumentError) { MerlinUk::Performance.at('MER_REDR', from: DATE, to: DATE - 1) }
  end

  private

  def performances_at(cinema_id)
    MerlinUk::Performance.at(cinema_id, from: Date.new(2026, 11, 1), to: Date.new(2027, 11, 1))
  end

  def find(cinema_id, perf_code)
    performances_at(cinema_id).detect { |p| p.booking_url.end_with?("perfCode=#{perf_code}") }
  end
end
