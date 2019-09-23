require 'rails_helper'

RSpec.describe TabFilter do
  context 'when no config is provided' do
    it 'raises an exception' do
      input = <<~HEREDOC
        ```tabbed_examples
        ```
      HEREDOC

      expect do
        described_class.new.call(input)
      end.to raise_error('Source or tabs must be present in this tabbed_example config')
    end
  end

  context 'when an invalid config is provided' do
    it 'raises an exception' do
      input = <<~HEREDOC
        ```tabbed_examples
        foo: 'bar'
        ```
      HEREDOC

      expect do
        described_class.new.call(input)
      end.to raise_error('Source or tabs must be present in this tabbed_example config')
    end
  end

  context 'when input is a directory' do
    it 'raises an exception if there is no .config.yml file' do
      expect(File).to receive(:directory?).and_return(true)
      expect(File).to receive(:exist?).and_return(false)
      input = 'nil'
      expect do
        described_class.new.call(input)
      end.to raise_error('Tabbed must be set to true in the folder config YAML file')
    end

    it 'raises an exception if tabbed parameter is not set to true' do
      expect(File).to receive(:read).with('/path/to/.config.yml').and_return(config_tabbed_false)
      expect do
        described_class.new.call(input)
      end.to raise_error('Tabbed must be set to true in the folder config YAML file')
    end
  end

  def config_tabbed_false
    <<~HEREDOC
      tabbed: false
    HEREDOC
  end
end
