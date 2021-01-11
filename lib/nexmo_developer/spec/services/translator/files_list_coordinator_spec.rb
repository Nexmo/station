require 'rails_helper'

RSpec.describe Translator::FilesListCoordinator do
  let(:days) { 30 }

  subject { described_class.new(days: days) }

  describe '#files' do
    context 'when there are changed files within the days given' do
      before { allow(subject).to receive(:files) { ['lib/nexmo_developer/spec/fixtures/_documentation/en/messaging/tiktok/overview.md', 'lib/nexmo_developer/spec/fixtures/_use_cases/en/dummy.md'] } }

      it 'returns an array of those files' do
        expect(subject.files).to eql(['lib/nexmo_developer/spec/fixtures/_documentation/en/messaging/tiktok/overview.md', 'lib/nexmo_developer/spec/fixtures/_use_cases/en/dummy.md'])
      end
    end

    context 'when there are no changed files within the days given' do
      before { allow(subject).to receive(:files) { [] } }

      it 'returns an empty array' do
        expect(subject.files).to eql([])
      end
    end
  end

  describe '#process_files' do
    it 'returns only files with allowed products' do
      expect(subject.process_files(['_documentation/en/warship/tiktok/overview.md', '_use_cases/en/dummy.md', '_documentation/en/vonage-business-cloud/vbc-apis/user-api/overview.md'])).to eql(['_use_cases/en/dummy.md'])
    end

    it 'raises an exception if the file is not from within a recognized documentation folder' do
      expect { subject.process_files(['_not_a_folder/klingon/war_ship/specs.md']) }.to raise_error(ArgumentError, 'The following file did not match documentation, use cases or tutorials: _not_a_folder/klingon/war_ship/specs.md')
    end
  end

  describe '#translatable_doc_file?' do
    it 'returns true when its in the allowed products list' do
      expect(subject.translatable_doc_file?('_documentation/en/voice/voice-api/guides/websockets.md')).to be true
    end

    it 'returns false when it is not in the allowed products list' do
      expect(subject.translatable_doc_file?('_documentation/en/not-a-ga-product/guides/not-here.md')).to be_falsey
    end
  end

  describe '#translatable_use_case_file?' do
    context 'with a product in the allowed products list' do
      before { allow(subject).to receive(:use_case_product) { 'messaging/sms' } }

      it 'returns true when it is in the allowed products list' do
        expect(subject.translatable_use_case_file?('_use_cases/en/sms-customer-support.md')).to be true
      end
    end

    context 'with a product not in the allowed products list' do
      before { allow(subject).to receive(:use_case_product) { 'martian/radar' } }

      it 'returns false' do
        expect(subject.translatable_use_case_file?('_use_cases/en/not-a-ga-product/guides/not-here.md')).to be_falsey
      end
    end
  end

  describe '#translatable_tutorial_file?' do
    context 'with a tutorial in the allowed products list' do
      before { allow(subject).to receive(:files).and_return(['_tutorials/en/voice/make-outbound-call.md']) }
      before { allow(TutorialList).to receive(:all).and_return([TutorialListItem.new("#{Rails.configuration.docs_base_path}/config/tutorials/en/voice-sample.yml")]) }

      it 'returns truie for a tutorial from an allowed product' do
        expect(subject.translatable_tutorial_file?('_tutorials/en/voice/make-outbound-call.md')).to be true
      end
    end

    context 'with a tutorial and a prerequisite file in the allowed products list' do
      before { allow(subject).to receive(:files).and_return(['_tutorials/en/voice/make-outbound-call.md', '_tutorials/en/run-ngrok.md']) }
      before { allow(TutorialList).to receive(:all).and_return([TutorialListItem.new("#{Rails.configuration.docs_base_path}/config/tutorials/en/voice-sample.yml")]) }

      it 'returns both the tutorial and its prerequisite' do
        file_list = subject.process_files(['_tutorials/en/voice/make-outbound-call.md', '_tutorials/en/run-ngrok.md'])

        expect(file_list).to eql(['_tutorials/en/voice/make-outbound-call.md', '_tutorials/en/run-ngrok.md'])
      end
    end

    context 'with a tutorial not in the allowed products list' do
      before { allow(subject).to receive(:files).and_return(['_tutorials/en/vulcan/first-contact.md']) }
      before { allow(TutorialList).to receive(:all).and_return([TutorialListItem.new("#{Rails.configuration.docs_base_path}/config/tutorials/en/voice-sample.yml")]) }

      it 'returns false' do
        expect(subject.translatable_tutorial_file?('_tutorials/en/vulcan/first-contact.md')).to be_falsey
      end
    end
  end
end
