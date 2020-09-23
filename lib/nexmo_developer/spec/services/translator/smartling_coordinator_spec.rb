require 'rails_helper'

RSpec.describe Translator::SmartlingCoordinator do
  describe '#coordinate_job' do
    it 'handles zero jobs' do
      subject = described_class.new(jobs: {})
      expect(subject.coordinate_jobs).to eql("foo")
    end

    it 'handles non-hashes' do
      subject = described_class.new(jobs: "Hello")
      expect(subject.coordinate_jobs).to eql("foo")
    end

    it 'handles jobs with a different type' do
      subject = described_class.new(jobs: {13 => ["a", "b"], 15 => "bar"})
      expect(subject.coordinate_jobs).to eql("foo")
    end

    it 'merges multiple jobs' do
      subject = described_class.new(jobs: {13 => ["a", "b"], 15 => ["c"], 17 => ["d", "e "]})
      expect(subject.coordinate_jobs).to eql("foo")
    end
  end
end
