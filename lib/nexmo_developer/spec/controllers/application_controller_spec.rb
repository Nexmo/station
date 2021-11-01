require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '.redirect_vonage_domain' do
    context 'production environment' do
      it 'call check_redirect_for' do
        rails_env_double = double('Rails env', production?: true, test?: true)
        allow(Rails).to receive(:env) { rails_env_double }
        application_controller = described_class.new
        allow(application_controller).to receive(:check_redirect_for)

        application_controller.redirect_vonage_domain

        expect(application_controller).to have_received(:check_redirect_for)
      end
    end

    context 'not production environment' do
      it 'does not call check_redirect_for' do
        rails_env_double = double('Rails env', production?: false, test?: false)
        allow(Rails).to receive(:env) { rails_env_double }
        application_controller = described_class.new
        allow(application_controller).to receive(:check_redirect_for)

        application_controller.redirect_vonage_domain

        expect(application_controller).not_to have_received(:check_redirect_for)
      end
    end
  end

  describe '.check_redirect_for' do
    context 'host: developer.OLD.com' do
      it 'calls redirect_to' do
        request = controller.request
        allow(request).to receive(:host) { 'developer.nexmo.com' }
        allow(request).to receive(:fullpath) { '/my_path' }
        allow(request).to receive(:protocol) { 'https://' }
        application_controller = described_class.new

        expect(application_controller).to receive(:redirect_to).with('https://developer.vonage.com/my_path', status: :moved_permanently)

        application_controller.check_redirect_for(request)
      end
    end

    context 'host: other.com' do
      it 'does not call redirect_to' do
        request = controller.request
        allow(request).to receive(:host) { 'other.com' }
        allow(request).to receive(:fullpath) { '/my_path' }
        allow(request).to receive(:protocol) { 'blob://' }
        application_controller = described_class.new

        expect(application_controller).not_to receive(:redirect_to)

        application_controller.check_redirect_for(request)
      end
    end
  end
end
