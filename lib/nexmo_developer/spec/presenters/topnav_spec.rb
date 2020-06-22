require 'rails_helper'

RSpec.describe Topnav do
  subject { described_class.new(:documentation) }

  describe '#items' do
    it 'returns an object with data from the config file' do
      expect(subject.items).to all(be_an_instance_of(TopnavItem))
    end
  end

  it 'raises an exception' do
    allow(File).to receive(:exist?).and_return(false)
    expect { subject }.to raise_error(RuntimeError, 'You must provide a config/top_navigation.yml file in your documentation path.')
  end
end
