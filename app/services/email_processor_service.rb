class EmailProcessorService
  def initialize(uploaded_email)
    @uploaded_email = uploaded_email
  end

  def process
    @uploaded_email.update(status: :processing)
    readed_email = read_email_content

    parser_class = select_parser_class(readed_email)

    raise "No parser found to email from: #{readed_email.from&.first}" unless parser_class

    parser = parser_class.new(readed_email)
    result = parser.parse!

    
    Rails.logger.info "[EmailProcessorService] Resultado: #{result.inspect}"

    if contact_data_missing?(result)
      @uploaded_email.update(status: :fail)
      log_failure('No contact data found', result)
      return { success: false, error: 'contact_data_missing', data: result }
    end
    
    customer = create_customer_from_data(result)
    log_success(result)
    @uploaded_email.update(status: :success)
    { success: true, customer: customer, data: result }
  rescue => e
    @uploaded_email.update(status: :fail) if @uploaded_email
    log_failure(e.message, result || {})
    { success: false, error: e.message}

  end

  private

  def read_email_content
    raw_data = @uploaded_email.eml_file.download
    Mail.read_from_string(raw_data)
  end

  def select_parser_class(email)
    from = Array(email.from).first.to_s.downcase
      {
        'fornecedora.com' => Parsers::FornecedorA,
        'parceirob.com' => Parsers::ParceiroB
      }.each do |domain, parser|
        return parser if from.include?(domain)
      end
      nil
  end

  def contact_data_missing?(data)
    data[:email].to_s.strip.empty? &&
    data[:phone].to_s.strip.empty? &&
    data[:name].to_s.strip.empty?
  end

  def log_success(data)
    ::EmailParserLog.create!(
      uploaded_email: @uploaded_email,
      level: :info,
      error_message: 'Client created successfully',
      extracted_data: data
    )
  end

  def log_failure(error_message, data)
    ::EmailParserLog.create!(
      uploaded_email: @uploaded_email,
      level: :error,
      error_message: error_message,
      extracted_data: data
    )
  end

  def create_customer_from_data(data)
    ::Customer.create!(
      name: data[:name],
      email: data[:email],
      phone: data[:phone],
      product_code: data[:product_code],
      subject: data[:subject]
    )
  end
end
