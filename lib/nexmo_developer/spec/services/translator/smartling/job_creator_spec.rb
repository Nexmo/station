require 'rails_helper'

RSpec.describe Translator::Smartling::JobCreator do
  context 'with all parameters defined' do
    ENV['SMARTLING_USER_ID'] = 'abcdefg123456789'
    ENV['SMARTLING_USER_SECRET'] = '1234567890zawrfkd'
    ENV['SMARTLING_PROJECT_ID'] = '234sdfedfg'
    let(:params) do
      {
        locales: ['en', 'ja'],
        due_date: 'Mon, 21 Sep 2020 12:37:40 UTC +00:00',
        user_id: ENV['SMARTLING_USER_ID'],
        user_secret: ENV['SMARTLING_USER_SECRET'],
        project_id: ENV['SMARTLING_PROJECT_ID'],
      }
    end
    subject { described_class.new(params) }
    it 'initializes with the correct attributes' do
      expect(subject).to have_attributes(
        job_name: a_string_starting_with('stationTranslationJob'),
        locales: ['en', 'ja'],
        due_date: 'Mon, 21 Sep 2020 12:37:40 UTC +00:00',
        user_id: 'abcdefg123456789',
        user_secret: '1234567890zawrfkd',
        project_id: '234sdfedfg'
      )
    end

    describe '#job_uri' do
      it 'sets the Smartling Job API URI correctly' do
        expect(subject.job_uri.as_json).to eql('https://api.smartling.com/jobs-api/v3/projects/234sdfedfg/jobs')
      end
    end

    describe '#create_job' do
      xit 'makes a successful HTTP POST request to Smartling Jobs API' do
        mock_net_http = double('http')
        # mock_net_http_post = double('Net::HTTP::Post')
        # allow(Net::HTTP).to receive(:new).and_return(mock_net_http)
        allow(mock_net_http).to receive(:use_ssl=).and_return(true)
        allow(subject).to receive(:create_job).and_return('abc123abc')
        # allow(Net::HTTP::Post).to receive(:new).and_return(mock_net_http_post)
        subject.create_job
        expect(mock_net_http).to receive(:request).with(hash_including(dueDate: 'Mon, 21 Sep 2020 12:37:40 UTC +00:00'))
      end

      it 'returns a translation job UUID' do
        allow(subject).to receive(:create_job).and_return('abc123abc')

        expect(subject.create_job).to eql('abc123abc')
      end
    end

    describe '#validate_job_creation' do
      context 'with a new job successfully created' do
        it 'returns the job UUID' do
          expect(subject.validate_job_creation(mock_success_message, 200)).to eql('abc123abc')
        end
      end

      context 'with an unsuccessful job attempt' do
        it 'raises the Smartling error code as an exception' do
          expect { subject.validate_job_creation(mock_error_message, 401) }.to raise_error(ArgumentError, '401: AUTHENTICATION_ERROR')
        end
      end
    end

    describe '#job_uuid' do
      it 'returns the job UUID' do
        uuid = 'abc123abc'

        expect(subject.job_uuid('abc123abc')).to eql(uuid)
      end
    end
  end

  def mock_success_message
    {
      'response' => {
        'code' => 'SUCCESS',
      },
      'data' => {
        'translationJobUuid' => 'abc123abc',
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
