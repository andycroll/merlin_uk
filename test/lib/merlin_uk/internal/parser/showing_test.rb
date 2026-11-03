require_relative '../../../../test_helper'

class MerlinUk::Internal::Parser::ShowingTest < Minitest::Test
  STARTING_AT = Time.utc(2026, 11, 4, 19, 15)
  BOOKING_URL = 'https://merlinredruth.admit-one.eu/?p=tickets&perfCode=93217'.freeze

  def test_to_hash
    expected = {
      booking_url: BOOKING_URL,
      dimension: '2d',
      festival: nil,
      film_name: 'Psycho',
      film_year: 1960,
      language: nil,
      starting_at: STARTING_AT,
      title: 'Picture House presents Psycho (1960)',
      variant: []
    }

    assert_equal expected, showing('Picture House presents Psycho (1960)').to_hash
  end

  def test_icons_mark_variants
    assert_equal %w(relaxed baby subtitled), variant('Film', keys: %w(access autism baby box licensed subtitled))
  end

  def test_cheap_tickets_and_seating_are_not_variants
    assert_empty variant('Film', keys: %w(access box licensed luxury saver))
  end

  def test_event_cinema_is_arts
    assert_equal %w(arts), variant('NT Live: Hay Fever', event_cinema: true)
  end

  def test_titles_mark_variants
    assert_equal %w(baby), variant('Bring Your Own Baby Screening: Super Nature')
    assert_equal %w(q&a), variant('Naza with Recorded Q&A')
  end

  def test_variants_are_not_repeated
    assert_equal %w(baby), variant('Bring Your Own Baby Screening: The Summer Book', keys: %w(baby))
  end

  def test_three_d_and_language
    attributes = showing('Avatar 3D (Hindi)').to_hash

    assert_equal '3d', attributes[:dimension]
    assert_equal 'Hindi', attributes[:language]
    assert_equal 'Avatar', attributes[:film_name]
  end

  def test_performances_read_variants_from_the_raw_title
    attributes = showing('Relaxed Screening: Wicker').to_hash
    performance = MerlinUk::Performance.new(attributes.merge(cinema_id: 'MER_REDR', cinema_name: 'Redruth'))

    assert_equal 'Wicker', performance.film_name
    assert_equal %w(relaxed), performance.variant
  end

  private

  def showing(title, event_cinema: false, keys: [])
    MerlinUk::Internal::Parser::Showing.new(
      title: title, event_cinema: event_cinema, starting_at: STARTING_AT, booking_url: BOOKING_URL, keys: keys
    )
  end

  def variant(title, **options)
    showing(title, **options).to_hash[:variant]
  end
end
