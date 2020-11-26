require 'rails_helper'

RSpec.describe Translator::TranslationRequest do
  subject do
    described_class.new(
      locale: 'ja-JP',
      frequency: 15,
      file_uri: 'messaging/sms/overview.md',
      file_path: "#{Rails.configuration.docs_base_path}/en/messaging/sms/overview.md"
    )
  end

  it 'returns an instance its class' do
    expect(subject).to be_an_instance_of(described_class)
  end

  it 'returns an instance with correct locale attribute' do
    expect(subject.locale).to eql('ja-JP')
  end

  it 'returns an instance with correct frequency attribute' do
    expect(subject.frequency).to eql(15)
  end

  it 'returns an instance with correct file_uri attribute' do
    expect(subject.file_uri).to eql('messaging/sms/overview.md')
  end
end
