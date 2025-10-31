# spec/jobs/email_processor_job_spec.rb
require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe EmailProcessorJob, type: :job do
  let(:eml_file_path) { Rails.root.join('spec', 'fixtures', 'emails', 'email1.eml') }
  let(:uploaded_email) do
    create(:uploaded_email).tap do |record|
      record.eml_file.attach(
        io: File.open(eml_file_path),
        filename: 'email1.eml',
        content_type: 'message/rfc822'
      )
    end
  end

  before { Sidekiq::Testing.fake! }

  describe '#perform' do
    context 'when the UploadedEmail exists' do
      it 'calls EmailProcessorService with the uploaded email' do
        service_double = instance_double(EmailProcessorService, process: true)
        allow(EmailProcessorService).to receive(:new).with(uploaded_email).and_return(service_double)

        described_class.new.perform(uploaded_email.id)

        expect(EmailProcessorService).to have_received(:new).with(uploaded_email)
        expect(service_double).to have_received(:process)
      end
    end

    context 'when the UploadedEmail does not exist' do
      it 'logs an error and does not call the service' do
        allow(Rails.logger).to receive(:error)
        allow(EmailProcessorService).to receive(:new)

        described_class.new.perform(-999)

        expect(Rails.logger).to have_received(:error)
          .with(/UploadedEmail -999 nao encontrado/)
        expect(EmailProcessorService).not_to have_received(:new)
      end
    end

    context 'when EmailProcessorService raises an exception' do
      it 'logs the error and re-raises it' do
        service_double = instance_double(EmailProcessorService)
        allow(EmailProcessorService).to receive(:new).and_return(service_double)
        allow(service_double).to receive(:process).and_raise(StandardError, 'Boom!')
        allow(Rails.logger).to receive(:error)

        expect {
          described_class.new.perform(uploaded_email.id)
        }.to raise_error(StandardError, 'Boom!')

        expect(Rails.logger).to have_received(:error)
          .with(/EmailProcessorJob failed for ##{uploaded_email.id}: StandardError - Boom!/)
      end
    end
  end

  describe 'Sidekiq behavior' do
    it 'enqueues a job with the correct arguments' do
      expect {
        described_class.perform_async(uploaded_email.id)
      }.to change(described_class.jobs, :size).by(1)

      job = described_class.jobs.last
      expect(job['args']).to eq([uploaded_email.id])
    end

    it 'runs inline and calls the service' do
      service_double = instance_double(EmailProcessorService, process: true)
      allow(EmailProcessorService).to receive(:new).and_return(service_double)

      Sidekiq::Testing.inline! do
        described_class.perform_async(uploaded_email.id)
      end

      expect(EmailProcessorService).to have_received(:new).with(instance_of(UploadedEmail))
      expect(service_double).to have_received(:process)
    end
  end
end
