module Parsers
  class FornecedorA < Base
    PATTERN_KEYS = {
      name: [ "Nome do cliente", "Nome" ],
      email: [ "E-mail", "Email" ],
      phone: [ "Telefone" ],
      product_code: []
    }.freeze

    def parse!
      data = extract_pattern(PATTERN_KEYS)

      product_match = @body.match(/produto de código\s*([A-Z0-9\-]+)/i) ||
                      @body.match(/produto\s*([A-Z0-9\-]+)/i)
      data[:product_code] = product_match[1] if product_match
      data[:subject] = @email.subject
      data
    end
  end
end
