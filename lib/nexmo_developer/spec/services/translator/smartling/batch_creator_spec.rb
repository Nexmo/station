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
      it 'returns a batch UUID' do
        allow(subject).to receive(:create_batch).and_return('qwe0rty98poi')

        expect(subject.create_batch).to eql('qwe0rty98poi')
      end
    end
  end
end
