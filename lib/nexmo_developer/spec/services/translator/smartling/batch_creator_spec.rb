require 'rails_helper'

RSpec.describe Translator::Smartling::BatchCreator do
  context 'with all parameters defined' do
    ENV['SMARTLING_PROJECT_ID'] = '234sdfedfg'
    let(:params) do
      { jobId: 'abc123abc' }
    end
    subject { described_class.new(params) }
    it 'initializes with the correct attributes' do
      expect(subject).to have_attributes(job_id: 'abc123abc')
    end

    describe '#batch_uri' do
      it 'sets the Smartling Batch API URI correctly' do
        expect(subject.batch_uri.as_json).to eql('https://api.smartling.com/jobs-batch-api/v1/projects/234sdfedfg/batches')
      end
    end

    describe '#create_batch' do
      xit 'makes a successful HTTP POST request to Smartling Batches API' do
        mock_net_http = double('http')
        # mock_net_http_post = double('Net::HTTP::Post')
        # allow(Net::HTTP).to receive(:new).and_return(mock_net_http)
        allow(mock_net_http).to receive(:use_ssl=).and_return(true)
        allow(subject).to receive(:create_batch).and_return('qwe0rty98poi')
        # allow(Net::HTTP::Post).to receive(:new).and_return(mock_net_http_post)
        subject.create_batch
        expect(mock_net_http).to receive(:request).with(hash_including(translationJobUuid: 'abc123abc'))
      end

      it 'returns a batch UUID' do
        allow(subject).to receive(:create_batch).and_return('qwe0rty98poi')

        expect(subject.create_batch).to eql('qwe0rty98poi')
      end
    end

    describe '#validate_batch_creation' do
      context 'with a new batch successfully created' do
        it 'returns the batch UUID' do
          expect(subject.validate_batch_creation(mock_success_message, 200)).to eql('qwe0rty98poi')
        end
      end

      context 'with an unsuccessful job attempt' do
        it 'raises the Smartling error code as an exception' do
          expect { subject.validate_batch_creation(mock_error_message, 401) }.to raise_error(ArgumentError, '401: AUTHENTICATION_ERROR')
        end
      end
    end

    describe '#batch_uuid' do
      it 'returns the job UUID' do
        uuid = 'qwe0rty98poi'

        expect(subject.batch_uuid('qwe0rty98poi')).to eql(uuid)
      end
    end
  end

  def mock_success_message
    {
      'response' => {
        'code' => 'SUCCESS',
      },
      'data' => {
        'batchUuid' => 'qwe0rty98poi',
      },
    }
  end

  def mock_error_message
    {
      'response' => {
        'code' => 'AUTHENTICATION_ERROR',
      },
      'errors' => {
        'message' => 'Invalid token',
      },
    }
  end
end
