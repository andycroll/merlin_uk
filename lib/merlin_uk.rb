require 'cgi/escape'
require 'date'

require 'cinebase'

require_relative './merlin_uk/version'

require_relative './merlin_uk/internal/http'
require_relative './merlin_uk/internal/website'
require_relative './merlin_uk/internal/title_sanitizer'
require_relative './merlin_uk/internal/parser/showing'
require_relative './merlin_uk/internal/parser/schedule'

require_relative './merlin_uk/cinema'
require_relative './merlin_uk/performance'

# merlin_uk gem
module MerlinUk
end
