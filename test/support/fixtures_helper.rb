# Read fixtures from disk: venue home pages trimmed to a few films, with
# the page's head and navigation removed. They follow the shape in
# page_shapes.rb.
module FixturesHelper
  private

  def venue_html(code)
    read_fixture("venues/#{code}.html")
  end

  def read_fixture(filepath)
    File.read(File.expand_path("../../fixtures/#{filepath}", __FILE__), encoding: Encoding::UTF_8)
  end
end
