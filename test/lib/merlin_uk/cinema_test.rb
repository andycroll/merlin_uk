require_relative '../../test_helper'

class MerlinUk::CinemaTest < Minitest::Test
  IDS = %w(
    MER_BODM MER_HELS MER_FALM MER_REDR MER_STIV MER_PENZ MER_RITZ MER_ILFR MER_KING MER_OKEH MER_TORQ
    MER_TIVE MER_COLE MER_CROM MER_REDC MER_WEST MER_WELL MER_AYRS MER_THUR MER_GALA MER_PRES MER_RHYL
  ).freeze

  def test_all_returns_every_venue_without_requests
    cinemas = MerlinUk::Cinema.all

    assert(cinemas.all? { |cinema| cinema.instance_of?(MerlinUk::Cinema) })
    assert_equal IDS, cinemas.map(&:id)
  end

  def test_new_stores_upcase_string_id
    assert_equal 'MER_REDR', MerlinUk::Cinema.new('mer_redr').id
  end

  def test_name_full_name_and_slug
    cinema = MerlinUk::Cinema.new('MER_REDR')

    assert_equal 'Regal Cinema & Theatre, Redruth', cinema.name
    assert_equal 'Merlin Regal Cinema & Theatre, Redruth', cinema.full_name
    assert_equal 'merlin-regal-cinema-theatre-redruth', cinema.slug
  end

  def test_brand
    assert_equal 'Merlin', MerlinUk::Cinema.new('MER_REDR').brand
  end

  def test_url
    assert_equal 'https://wsm.merlincinemas.co.uk', MerlinUk::Cinema.new('MER_WEST').url
  end

  def test_adr
    expected = {
      street_address:   'West Parade',
      extended_address: 'The Village',
      locality:         'Rhyl',
      region:           'Denbighshire',
      postal_code:      'LL18 1HB',
      country_name:     'United Kingdom'
    }

    assert_equal expected, MerlinUk::Cinema.new('MER_RHYL').adr
  end

  def test_coordinates
    cinema = MerlinUk::Cinema.new('MER_REDR')

    assert_in_delta 50.233212, cinema.latitude
    assert_in_delta(-5.229744, cinema.longitude)
  end

  def test_every_venue_has_an_address_and_coordinates
    MerlinUk::Cinema.all.each do |cinema|
      refute_empty cinema.street_address, cinema.id
      refute_empty cinema.locality, cinema.id
      refute_empty cinema.region, cinema.id
      assert_match(/\A[A-Z]{1,2}\d{1,2} \d[A-Z]{2}\z/, cinema.postal_code, cinema.id)
      assert_kind_of Float, cinema.latitude, cinema.id
      assert_kind_of Float, cinema.longitude, cinema.id
    end
  end

  def test_unknown_cinema_has_no_details
    cinema = MerlinUk::Cinema.new('MER_ZZZZ')

    assert_equal '', cinema.name
    assert_equal '', cinema.url
    assert_nil cinema.latitude
  end
end
