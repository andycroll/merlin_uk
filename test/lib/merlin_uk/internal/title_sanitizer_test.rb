require_relative '../../../test_helper'

class MerlinUk::Internal::TitleSanitizerTest < Minitest::Test
  def test_plain_titles_are_unchanged
    assert_sanitized 'Ghosts: The Possession Of Button House', 'Ghosts: The Possession Of Button House'
  end

  def test_exhibition_on_screen
    assert_sanitized 'Exhibition on Screen: Renoir & Love', 'Exhibition On Screen: Renoir & Love'
  end

  def test_parent_and_baby_prefix
    assert_sanitized 'The Summer Book', 'Bring Your Own Baby Screening: The Summer Book'
  end

  def test_film_society_prefixes
    assert_sanitized 'Psycho', 'Picture House presents Psycho (1960)'
    assert_sanitized 'Barry Lyndon', 'PFS presents: Barry Lyndon'
  end

  def test_special_screening_prefix
    assert_sanitized '2026 BritRock Film Tour Gala Screening', 'Special Screening: 2026 BritRock Film Tour Gala Screening'
  end

  def test_q_and_a_suffixes
    assert_sanitized 'No Trees No Seas', 'No Trees No Seas with Q&A'
    assert_sanitized 'Naza', 'Naza with Recorded Q&A'
    assert_sanitized 'All Rivers Spill Their Stories To The Sea',
                     'All Rivers Spill Their Stories To The Sea with Pre Recorded Q&A'
  end

  def test_ritz_suffix
    assert_sanitized 'The Godfather', 'The Godfather at The Ritz'
    assert_sanitized 'Die Hard', 'Die Hard at the Ritz'
  end

  def test_national_theatre_live
    assert_sanitized 'National Theatre Live: Hay Fever', 'NT Live: Hay Fever'
  end

  def test_royal_ballet_and_opera
    assert_sanitized 'Royal Ballet and Opera: Swan Lake', 'RBO 2026-27: The Royal Ballet - Swan Lake'
    assert_sanitized 'Royal Ballet and Opera: Tosca', 'RBO 2026-27: The Royal Opera - Tosca'
    assert_sanitized 'Met Opera: La Fanciulla Del West', 'RBO 2026-27: MET Opera - La Fanciulla Del West'
  end

  private

  def assert_sanitized(expected, title)
    assert_equal expected, MerlinUk::Internal::TitleSanitizer.new(title).sanitized
  end
end
