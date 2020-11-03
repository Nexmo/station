require 'rails_helper'

# rubocop:disable Layout/HeredocIndentation
RSpec.describe FeedbackSlackNotifier do
  let(:config_file) { "#{Rails.configuration.docs_base_path}/config/feedback.yml" }
  let!(:config) { Feedback::Config.find_or_create_config(YAML.safe_load(File.read(config_file))) }
  let!(:feedback) do
    Feedback::Feedback.new(
      config: config,
      sentiment: 'positive',
      path: 0,
      steps: ['nothing!']
    )
  end

  subject { described_class.new(feedback) }

  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('SLACK_WEBHOOK').and_return('webhook')
  end

  describe '#emoji' do
    context 'positive' do
      let(:feedback) { Feedback::Feedback.new(sentiment: 'positive') }

      it { expect(subject.emoji).to eq(':+1:') }
    end

    context 'negative' do
      let(:feedback) { Feedback::Feedback.new(sentiment: 'negative') }

      it { expect(subject.emoji).to eq(':-1:') }
    end

    context 'neutral' do
      let(:feedback) { Feedback::Feedback.new(sentiment: 'neutral') }

      it { expect(subject.emoji).to eq(':neutral_face:') }
    end
  end

  describe '#slack_color' do
    context 'positive' do
      let(:feedback) { Feedback::Feedback.new(sentiment: 'positive') }

      it { expect(subject.slack_color).to eq('good') }
    end

    context 'negative' do
      let(:feedback) { Feedback::Feedback.new(sentiment: 'negative') }

      it { expect(subject.slack_color).to eq('danger') }
    end

    context 'neutral' do
      let(:feedback) { Feedback::Feedback.new(sentiment: 'neutral') }

      it { expect(subject.slack_color).to eq('#ccc') }
    end
  end

  describe '#state' do
    let(:date_time) { DateTime.now }

    context 'new feedback' do
      let(:feedback) do
        Feedback::Feedback.new(
          sentiment: 'neutral',
          created_at: date_time,
          updated_at: date_time
        )
      end

      it { expect(subject.state).to eq('New') }
    end

    context 'existing feedback' do
      let(:feedback) do
        Feedback::Feedback.new(
          sentiment: 'neutral',
          created_at: date_time,
          updated_at: date_time + 1.day
        )
      end

      it { expect(subject.state).to eq('Updated') }
    end
  end

  describe '#paths' do
    it 'renders the different paths and highlights the selected one' do
      text = <<~HEREDOC.chomp
        *I found what I needed to know - thanks!*
        There is a problem with the documentation.
        I am having problems with the sample code.
        I need help with something else.
        I don’t understand any of this!
      HEREDOC

      expect(subject.paths.join("\n")).to eq(text)
    end
  end

  describe '#answers' do
    it 'renders the submitted answers' do
      text = <<~HEREDOC.chomp
        *Anything we can improve on?*
        \t\tnothing!

        *Thank You!*
      HEREDOC

      expect(subject.answers.join("\n")).to eq(text)
    end
  end

  describe '#body' do
    it 'renders the paths and answers' do
      text = <<~HEREDOC
        Great! Please let us know what you think:

        *Paths:*
        \t*I found what I needed to know - thanks!*
        \tThere is a problem with the documentation.
        \tI am having problems with the sample code.
        \tI need help with something else.
        \tI don’t understand any of this!

        *Answers:*
        \t*Anything we can improve on?*
        \t\tnothing!

        \t*Thank You!*
      HEREDOC

      expect(subject.body).to eq(text)
    end

    context 'with a radiogroup' do
      let!(:feedback) do
        Feedback::Feedback.new(
          config: config,
          sentiment: 'positive',
          path: 1,
          steps: [1, 'write better docs!']
        )
      end

      it 'renders the paths and answers' do
        text = <<~HEREDOC
          Great! Please let us know what you think:

          *Paths:*
          \tI found what I needed to know - thanks!
          \t*There is a problem with the documentation.*
          \tI am having problems with the sample code.
          \tI need help with something else.
          \tI don’t understand any of this!

          *Answers:*
          \t*Thanks for letting us know!
          Please, tell us more:*
          \t\tThe documentation is missing information.
          \t\t*The documentation is unclear.*
          \t\tThe documentation is incorrect.
          \t\tThere is a broken link.
          \t\tI don’t understand the terminology.

	  \t*What have we left out?*
          \t\twrite better docs!

          \t*Thank You!*
        HEREDOC

        expect(subject.body).to eq(text)
      end
    end

    context 'with a fieldset' do
      let!(:feedback) do
        Feedback::Feedback.new(
          config: config,
          sentiment: 'positive',
          path: 3,
          steps: [
            1,
            {
              'name' => 'John Doe',
              'email' => 'john.doe@vonage.com',
              'feedback' => 'I don\'t understand any of this!',
              'companyName' => 'Vonage',
            },
          ]
        )
      end

      it 'renders the paths and answers' do
        text = <<~HEREDOC
          Great! Please let us know what you think:

          *Paths:*
          \tI found what I needed to know - thanks!
          \tThere is a problem with the documentation.
          \tI am having problems with the sample code.
          \t*I need help with something else.*
          \tI don’t understand any of this!

          *Answers:*
          \t*What do you need help with?*
          \t\tMy account/billing.
          \t\t*The capabilities of the product.*
          \t\tSomething else.

	  \t*Let's get you some help!*
          \t\t*Your name:* John Doe
          \t\t*Email:* john.doe@vonage.com
          \t\t*Company Name:* Vonage
          \t\t*Please tell us how we can help you:* I don't understand any of this!

          \t*Thank You!*
        HEREDOC

        expect(subject.body).to eq(text)
      end
    end
  end
end
# rubocop:enable Layout/HeredocIndentation
