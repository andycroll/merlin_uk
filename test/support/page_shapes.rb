# The parts of a venue's home page the gem reads. Checked against the
# trimmed fixtures and, in the live suite, against real pages held only in
# memory.
module PageShapes
  BOOKING_URL = %r{\Ahttps://merlin[a-z]+\.admit-one\.eu/\?p=tickets&perfCode=\d+\z}
  CARD = /<div class="filmCard full" data-film="\d+-[\w-]+">/
  DATE = /\A(?:Mon|Tues|Wednes|Thurs|Fri|Satur|Sun)day \d{1,2}(?:st|nd|rd|th) [A-Z][a-z]+(?: 20\d{2})?\z/
  KNOWN_KEYS = %w(access autism baby box licensed luxury saver subtitled).freeze

  private

  def assert_page_shape(html)
    assert_match(/<li data-date="\d{4}-\d{2}-\d{2}">/, html)
    full = html[MerlinUk::Internal::Parser::Schedule::FULL, 1]
    refute_nil full
    assert_match CARD, full
    full.scan(%r{<h5>([^<]*)</h5>}).flatten.each { |heading| assert_match DATE, heading }
    links = full.scan(%r{<a href="([^"]*perfCode[^"]*)"[^>]*>(.*?)</a>}m)
    refute_empty links
    links.each { |href, link| assert_link_shape(href, link) }
  end

  def assert_link_shape(href, link)
    assert_match BOOKING_URL, href
    assert_match(/\A\d{2}:\d{2}\z/, link.gsub(/<[^>]*>/, '').strip)
    link.scan(/data-key="([^"]+)"/).flatten.each { |key| assert_includes KNOWN_KEYS, key }
  end
end
