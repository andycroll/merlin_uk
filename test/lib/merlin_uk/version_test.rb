require_relative '../../test_helper'

class MerlinUk::VersionTest < Minitest::Test
  def test_version_is_defined
    refute_nil MerlinUk::VERSION
  end
end
