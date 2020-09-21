require 'rails_helper'

RSpec.describe Translator::TranslationRequest do
  subject { described_class.new(locale: 'ja', frequency: 15, path: 'a/sample/path/doc.md') }

  it 'returns an instance its class' do
    expect(subject).to be_an_instance_of(Translator::TranslationRequest)
  end

  it 'returns an instance with correct locale attribute' do
    expect(subject.locale).to eql('ja')
  end

  it 'returns an instance with correct frequency attribute' do
    expect(subject.frequency).to eql(15)
  end

  it 'returns an instance with correct path attribute' do
    expect(subject.path).to eql('a/sample/path/doc.md')
  end
end
