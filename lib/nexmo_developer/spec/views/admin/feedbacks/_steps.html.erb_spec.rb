require 'rails_helper'

RSpec.describe 'admin/feedbacks/_steps.html.erb' do
  let(:config) do
    Feedback::Config.find_or_create_config(
      YAML.safe_load(
        File.read("#{Rails.root}/config/feedback.yml")
      )
    )
  end
  let(:feedback) do
    FactoryBot.create(
      :feedback_feedback,
      config: config,
      path: 3,
      steps: []
    )
  end

  it 'renders the corresponding specs' do
    expect(OrbitFeedbackNotifier).to receive(:call)

    render partial: 'admin/feedbacks/steps.html.erb', locals: { feedback: feedback }

    expect(rendered).to have_css('b', text: 'I need help with something else.')

    expect(rendered).to have_css('div', text: 'My account/billing.')
    expect(rendered).to have_css('div', text: 'The capabilities of the product.')
    expect(rendered).to have_css('div', text: 'Something else.')
  end
end
