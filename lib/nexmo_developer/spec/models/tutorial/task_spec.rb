require 'rails_helper'

RSpec.describe Tutorial::Task, type: :model do
  let(:current_step) { 'introduction' }

  subject do
    described_class.new(
      name: name,
      title: 'Create a voice application',
      current_step: current_step,
      description: 'Learn how to create a voice application'
    )
  end

  describe '#validate!' do
    context 'with a valid task' do
      let(:name) { 'application/create-voice' }

      it 'does not have errors' do
        subject.validate!

        expect(subject.errors).to be_empty
      end
    end

    context 'with an invalid task' do
      let(:name) { 'non-existent-task' }

      it 'has errors' do
        subject.validate!

        expect(subject.errors).not_to be_empty
        expect(subject.errors.messages[:name].to_a).to match_array(['could not find the file: non-existent-task'])
      end
    end
  end
end
