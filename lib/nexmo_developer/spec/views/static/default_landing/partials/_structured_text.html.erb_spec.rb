require 'rails_helper'

RSpec.describe 'rendering _structured_text landing page partial' do
  it 'renders correctly with local variable' do
    render partial: '/static/default_landing/partials/structured_text.html.erb', locals: {
        'icon' => { 'name' => 'nexmo-circle', 'color' => 'blue' },
        'header' => 'My header',
        'text' => [
          { 'type' => 'small', 'content' => 'Things here' },
          { 'type' => 'large', 'content' => 'Large things here' },
        ],
    }

    expect(rendered).to include('<svg class="Vlt-blue">')
    expect(rendered).to include('<use xlink:href="/symbol/volta-icons.svg#Vlt-nexmo-circle">')
    expect(rendered).to include('My header')
    # remove all new line breaks and whitespace from following test:
    expect(rendered.tr("\n", ' ').gsub(/\s+/, '')).to include('<p class="p-large">Large things here'.tr("\n", ' ').gsub(/\s+/, ''))
    expect(rendered).to include('Things here')
  end

  it 'renders without an icon if an icon is not provided' do
    render partial: '/static/default_landing/partials/structured_text.html.erb', locals: {
      'header' => 'My header',
      'text' => [
        { 'type' => 'small', 'content' => 'Things here' },
        { 'type' => 'large', 'content' => 'Large things here' },
      ],
    }

    expect(rendered).to_not include('use xlink:href')
  end

  it 'raises an error if icon key is provided without icon color' do
    expect do
      render partial: '/static/default_landing/partials/structured_text.html.erb', locals: {
        'icon' => { 'name' => 'nexmo-circle' },
        'header' => 'My header',
        'text' => [
          { 'type' => 'small', 'content' => 'Things here' },
          { 'type' => 'large', 'content' => 'Large things here' },
        ],
    }
    end.to raise_error("Missing 'icon color' key in structured_text landing page icon block")
  end

  it 'raises an error if icon key is provided without icon name' do
    expect do
      render partial: '/static/default_landing/partials/structured_text.html.erb', locals: {
        'icon' => { 'color' => 'blue' },
        'header' => 'My header',
        'text' => [
          { 'type' => 'small', 'content' => 'Things here' },
          { 'type' => 'large', 'content' => 'Large things here' },
        ],
    }
    end.to raise_error("Missing 'icon name' key in structured_text landing page icon block")
  end

  it 'raises an error if a header is not provided' do
    expect do
      render partial: '/static/default_landing/partials/structured_text.html.erb', locals: {
        'icon' => { 'name' => 'nexmo-circle', 'color' => 'blue' },
        'text' => [
          { 'type' => 'small', 'content' => 'Things here' },
          { 'type' => 'large', 'content' => 'Large things here' },
        ],
    }
    end.to raise_error("Missing 'header' key in structured_text landing page block")
  end

  it 'raises an error if text is not provided' do
    expect do
      render partial: '/static/default_landing/partials/structured_text.html.erb', locals: {
        'icon' => { 'name' => 'nexmo-circle', 'color' => 'blue' },
        'header' => 'My header',
    }
    end.to raise_error("Missing 'text' key in structured_text landing page block")
  end
end
