module Parsers
  class ParceiroB < Base
    PATTERN_KEYS = {
      name: [ "Nome completo", "Nome do cliente", "Cliente" ],
      email: [ "E-mail de contato", "Email" ],
      phone: [ "Telefone" ],
      product_code: [ "Produto de interesse", "Código do produto", "Produto" ]
    }.freeze

    def parse!
      data = extract_pattern(PATTERN_KEYS)

      data[:subject] = @email.subject
      data
    end
  end
end
