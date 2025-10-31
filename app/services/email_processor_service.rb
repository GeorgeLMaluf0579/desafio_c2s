class EmailProcessorService
  def initialize(uploaded_email)
    @uploaded_email = uploaded_email
  end

  def process
    puts "Processing...."
  end
end