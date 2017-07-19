class SlackController < ApplicationController
  def join
  end

  def invite
    email = params[:email]

    if EmailValidator.is_valid?(email)
      response = RestClient.post "https://#{ENV['SLACK_SUBDOMAIN']}.slack.com/api/users.admin.invite", {
        token: ENV['SLACK_TOKEN'],
        email: email,
      }

      response = JSON.parse(response)

      if response['ok']
        @invitation_sent_successfully = true
        @notice = "An invitation has been sent to #{email}"
      else
        case response['error']
        when 'already_invited'
          @notice = "It looks like you've already been sent an invitation."
        when 'already_in_team'
          @notice = 'You are already a member of this Slack'
        else
          Bugsnag.notify('Slack Error') do |notification|
            notification.add_tab(:slack, { response: response })
          end
          @notice = 'Something went wrong. Please try again later.'
        end
      end
    else
      @notice = 'Invalid email, try again.'
    end

    render 'join'
  end
end
