require 'rails_helper'

RSpec.describe Translator::TranslationRequest do
  it 'returns an instance its class' do
    request = described_class.new(locale: 'ja', frequency: 15, path: 'a/sample/path/doc.md')

    expect(request).to be_an_instance_of(Translator::TranslationRequest)
  end

  it 'returns an instance with correct locale attribute' do
    request = described_class.new(locale: 'ja', frequency: 15, path: 'a/sample/path/doc.md')

    expect(request.locale).to eql('ja')
  end

  it 'returns an instance with correct frequency attribute' do
    request = described_class.new(locale: 'ja', frequency: 15, path: 'a/sample/path/doc.md')

    expect(request.frequency).to eql(15)
  end

  it 'returns an instance with correct path attribute' do
    request = described_class.new(locale: 'ja', frequency: 15, path: 'a/sample/path/doc.md')

    expect(request.path).to eql('a/sample/path/doc.md')
  end
end
