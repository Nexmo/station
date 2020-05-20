require 'rails_helper'

RSpec.describe Tutorial, type: :model do
  before do
    allow(File).to receive(:read).and_call_original
    allow(File).to receive(:exist?).and_call_original
  end

  before(:all) do
    @original_dictionary = Nexmo::Markdown::DocFinder.dictionary

    Nexmo::Markdown::DocFinder.configure do |config|
      config.paths << "#{Rails.configuration.docs_base_path}/config/tutorials"
      config.paths << "#{Rails.configuration.docs_base_path}/_tutorials"
    end
  end

  after(:all) do
    Nexmo::Markdown::DocFinder.dictionary = @original_dictionary
  end

  let(:application_subtask) do
    Nexmo::Markdown::Tutorial::Task.new(
      name: 'application/create-voice',
      title: 'Create a voice application',
      current_step: current_step,
      description: 'Learn how to create a voice application'
    )
  end

  let(:outbound_call_subtask) do
    Nexmo::Markdown::Tutorial::Task.new(
      name: 'voice/make-outbound-call',
      title: 'Make an outbound call',
      current_step: current_step,
      description: 'Simple outbound call example'
    )
  end

  let(:introduction_subtask) do
    Nexmo::Markdown::Tutorial::Task.new(
      name: 'introduction',
      title: 'Introduction Title',
      current_step: current_step,
      description: 'This is an introduction'
    )
  end

  let(:conclusion_subtask) do
    Nexmo::Markdown::Tutorial::Task.new(
      name: 'conclusion',
      title: 'Conclusion Title',
      current_step: current_step,
      description: 'This is a conclusion'
    )
  end

  let(:current_step) { 'introduction' }

  describe '#load' do
    it 'returns a single tutorial' do
      tutorial = described_class.load('example_tutorial', current_step)

      expect(tutorial).to be_kind_of(Tutorial)
      expect(tutorial.title).to eq('This is an example tutorial')
      expect(tutorial.description).to eq('Welcome to an amazing description')
      expect(tutorial.products).to eq(['demo-product'])
      expect(tutorial.subtasks).to eq([application_subtask, outbound_call_subtask])
    end

    it 'returns a tutorial with an introduction' do
      tutorial = described_class.load('with_intro', current_step)

      expect(tutorial.subtasks).to eq(
        [
          introduction_subtask,
          application_subtask,
          outbound_call_subtask,
        ]
      )
    end

    it 'returns a tutorial with a conclusion' do
      tutorial = described_class.load('with_conclusion', current_step)

      expect(tutorial.subtasks).to eq(
        [
          application_subtask,
          outbound_call_subtask,
          conclusion_subtask,
        ]
      )
    end

    it 'returns a tutorial with an introduction and a conclusion' do
      tutorial = described_class.load('with_intro_and_conclusion', current_step)

      expect(tutorial.subtasks).to eq(
        [
          introduction_subtask,
          application_subtask,
          outbound_call_subtask,
          conclusion_subtask,
        ]
      )
    end

    it 'returns a tutorial without tasks' do
      tutorial = described_class.load('without_tasks', current_step)

      expect(tutorial.title).to eq('No tutorials')
      expect(tutorial.description).to eq('Description here')
      expect(tutorial.products).to eq(['demo'])
    end

    context 'multi language' do
      let(:shared_task) do
        Nexmo::Markdown::Tutorial::Task.new(
          name: 'multi_language/shared',
          title: 'This is a shared task',
          current_step: current_step,
          description: 'It is shared between different code languages'
        )
      end

      let(:javascript_code_task) do
        Nexmo::Markdown::Tutorial::Task.new(
          name: 'multi_language/code',
          title: 'Javascript specific `code` task',
          current_step: current_step,
          description: 'Specific definition of the task `code` for Javascript'
        )
      end

      let(:python_code_task) do
        Nexmo::Markdown::Tutorial::Task.new(
          name: 'multi_language/code',
          title: 'Python specific `code` task',
          current_step: current_step,
          description: 'Specific definition of the task `code` for Python'
        )
      end

      context 'specifying a code_language' do
        it 'loads the corresponding the tutorial in javascript' do
          tutorial = described_class.load('multi_language', current_step, nil, 'javascript')

          expect(tutorial.available_code_languages).to eq(['javascript', 'python'])
          expect(tutorial.code_language).to eq('javascript')
          expect(tutorial.title).to eq('Javascript title')
          expect(tutorial.description).to eq('Javascript description')
          expect(tutorial.subtasks).to eq([shared_task, javascript_code_task])
        end

        it 'loads the corresponding the tutorial in python' do
          tutorial = described_class.load('multi_language', current_step, nil, 'python')

          expect(tutorial.available_code_languages).to eq(['javascript', 'python'])
          expect(tutorial.code_language).to eq('python')
          expect(tutorial.title).to eq('Python title')
          expect(tutorial.description).to eq('Python description')
          expect(tutorial.subtasks).to eq([shared_task, python_code_task])
        end
      end

      context 'without specifying a code_language' do
        it 'selects the code_language with the highest weight' do
          tutorial = described_class.load('multi_language', current_step)

          expect(tutorial.available_code_languages).to eq(['javascript', 'python'])
          expect(tutorial.code_language).to eq('javascript')
          expect(tutorial.title).to eq('Javascript title')
          expect(tutorial.description).to eq('Javascript description')
          expect(tutorial.subtasks).to eq([shared_task, javascript_code_task])
        end
      end
    end
  end

  describe '#current_product' do
    it 'respects the product if provided' do
      tutorial = described_class.load('example_tutorial', current_step, 'banana')

      expect(tutorial.current_product).to eq('banana')
    end

    it 'defaults to the first item in the products list if not provided' do
      tutorial = described_class.load('example_tutorial', current_step)

      expect(tutorial.current_product).to eq('demo-product')
    end
  end

  describe '#next_step' do
    context 'current_step is conclusion' do
      let(:current_step) { 'conclusion' }

      it 'returns nil' do
        tutorial = described_class.load('with_intro_and_conclusion', current_step)

        expect(tutorial.next_step).to be_nil
      end
    end

    it 'returns the next step after an introduction' do
      tutorial = described_class.load('with_intro_and_conclusion', current_step)

      expect(tutorial.next_step).to eq(application_subtask)
    end

    context 'in the middle of the tutorial with more steps' do
      let(:current_step) { 'application/create-voice' }

      it 'returns the next step after a tutorial' do
        tutorial = described_class.load('with_intro_and_conclusion', current_step)

        expect(tutorial.next_step).to eq(outbound_call_subtask)
      end
    end
  end

  describe '#previous_step' do
    it 'returns nil if there is no previous step' do
      tutorial = described_class.load('with_intro_and_conclusion', current_step)

      expect(tutorial.previous_step).to be_nil
    end

    context 'current_step is conclusion' do
      let(:current_step) { 'conclusion' }

      it 'returns the previous step' do
        tutorial = described_class.load('with_intro_and_conclusion', current_step)

        expect(tutorial.previous_step).to eq(outbound_call_subtask)
      end
    end

    context 'in the middle of the tutorial with more steps' do
      let(:current_step) { 'voice/make-outbound-call' }

      it 'returns the previous step before a tutorial' do
        tutorial = described_class.load('with_intro_and_conclusion', current_step)

        expect(tutorial.previous_step).to eq(application_subtask)
      end
    end
  end

  describe '#first_step' do
    it 'returns introduction if it exists' do
      tutorial = described_class.load('with_intro', current_step)

      expect(tutorial.first_step).to eq('introduction')
    end

    it 'returns the first step if there is no introduction' do
      tutorial = described_class.load('example_tutorial', current_step)

      expect(tutorial.first_step).to eq('application/create-voice')
    end
  end

  describe '#content_for' do
    context 'introduction' do
      it 'returns content if it exists' do
        tutorial = described_class.load('with_intro', current_step)

        expect(tutorial.content_for('introduction')).to eq('Start of a tutorial')
      end

      it 'raises if it does not exist' do
        tutorial = described_class.load('example_tutorial', current_step)

        expect { tutorial.content_for('introduction') }.to raise_error('Invalid step: introduction')
      end
    end

    context 'conclusion' do
      it 'returns content if it exists' do
        tutorial = described_class.load('with_conclusion', current_step)

        expect(tutorial.content_for('conclusion')).to eq('End of a tutorial')
      end

      it 'raises if it does not exist' do
        tutorial = described_class.load('example_tutorial', current_step)

        expect { tutorial.content_for('conclusion') }.to raise_error('Invalid step: conclusion')
      end
    end

    context 'dynamic step' do
      # rubocop:disable Layout/ClosingHeredocIndentation
      it 'returns content if it exists' do
        tutorial = described_class.load('example_tutorial', current_step)

        expect(tutorial.content_for('application/create-voice')).to eq(<<~HEREDOC
          ---
          title: Create a voice application
          description: Learn how to create a voice application
          ---
          # Create a voice application
          Creating a voice application is very important. Please do it
                                                                       HEREDOC
          .strip + "\n")
      end
      # rubocop:enable Layout/ClosingHeredocIndentation

      it 'raises if it does not exist' do
        tutorial = described_class.load('example_tutorial', current_step)

        expect { tutorial.content_for('missing-step') }.to raise_error(Nexmo::Markdown::DocFinder::MissingDoc)
      end
    end
  end
end
