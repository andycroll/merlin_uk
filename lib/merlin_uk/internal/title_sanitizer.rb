module MerlinUk
  # Internal utility classes: Do not use
  # @api private
  module Internal
    # Sanitize and standardize film titles
    class TitleSanitizer < Cinebase::TitleSanitizer
      # @!method initialize(title)
      #   Constructor
      #   @param [String] title a film title
      #   @return [MerlinUk::Internal::TitleSanitizer]

      # @!method sanitized
      #   sanitized and standardized title
      #   @return [String] sanitised title

      private

      # strings and regex to be removed
      def remove
        [
          /\ABring Your Own Baby(?: Screening)?:\s*/i,        # parent and baby screening
          /\A(?:PFS|Picture House) presents:?\s*/i,           # film society prefix
          /\ASpecial Screening:\s*/i,                         # special screening prefix
          /\s+with\s+(?:Pre[- ]?)?(?:Recorded\s+)?Q&A\z/i,    # Q&A add-on
          /\s+at\s+the\s+Ritz\.?\z/i                          # Ritz Penzance suffix
        ] + COMMON_REMOVE
      end

      # regexes and their replacements
      def replace
        {
          /\ANT Live: (.*)/i                                  => 'National Theatre Live: ',
          /\ARBO 20\d{2}-\d{2}: MET Opera - (.*)/i            => 'Met Opera: ',
          /\ARBO 20\d{2}-\d{2}: The Royal (?:Ballet|Opera) - (.*)/i => 'Royal Ballet and Opera: '
        }.merge(COMMON_REPLACE)
      end
    end
  end
end
