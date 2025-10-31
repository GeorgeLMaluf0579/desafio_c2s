module Parsers
  class Base
    def initialize(email)
      @email = mail
      @body = normalized_body
    end

    def extract
      raise NotImplementedError, "Precisa implementar em subclasses"
    end

    def normalized_body
      if @email.multipart?
        part = @email.parts.find { |p| p.mime_type == 'text/plain' } || @mail.parts.first
        part.decoded
      else
        @email.body.decoded
      end
    end
  end
end