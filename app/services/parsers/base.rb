module Parsers
  class Base
    def initialize(email)
      @email = email
      @body = normalized_body
    end

    def parse!
      raise NotImplementedError, "Precisa implementar em subclasses"
    end

    private

    def normalized_body
      normalized_body_string = if @email.multipart?
                                 part = @email.parts.find { |p| p.content_type&.include?('text/plain') } || @email.parts.first
                                 part.decoded
                               else
                                 @email.body.decoded
                               end.to_s

      normalized_body_string.force_encoding("UTF-8").encode("UTF-8", invalid: :replace, undef: :replace, replace: "")
    end

    def extract_pattern(pattern)
      result = {}
      pattern.each do |key, labels|
        labels.each do |label|
          regex = /#{Regexp.escape(label)}:\s*(.+)/i
          match = @body.match(regex)
          if match
            result[key] = match[1].strip
            break
          end
        end
      end
      result
    end

    def extract_regex(label_regex)
      match = @body.match(label_regex)
      match && match[1].strip
    end
  end
end
