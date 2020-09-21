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

    describe '#client' do
      it 'creates a Smartling SDK instance' do
        expect(subject.client).to be_an_instance_of(Smartling::Api)
      end
    end

    describe '#job_uri' do
      it 'sets the Smartling Job API URI correctly' do
        expect(subject.job_uri.as_json).to eql('https://api.smartling.com/jobs-api/v3/projects/234sdfedfg/jobs')
      end
    end
  end
end
