class JobsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def code_example_push
    if validate_github_signature
      url = "https://api.travis-ci.org/repo/#{ENV['TRAVIS_REPO_ID']}/requests"

      RestClient.post(url, {
        "request": {
          "branch": 'ci/diff',
          "config": {
            "script": 'rake diff:execute',
          },
        },
      }.to_json, {
        content_type: :json,
        accept: :json,
        'Authorization': "token #{ENV['TRAVIS_TOKEN']}",
        'Travis-API-Version': '3',
      })

      head :ok
    else
      head :unauthorized
    end
  end

  def open_pull_request
    repo = ENV['GITHUB_REPO']
    branch_base = 'master'
    branch_head = params[:branch]
    title = '[AUTOMATED] Updated code examples'
    body = params[:body]

    client = Octokit::Client.new(access_token: ENV['GITHUB_PERSONAL_ACCESS_TOKEN'])
    client.login
    client.create_pull_request(repo, branch_base, branch_head, title, body)

    head :ok
  end

  private

  def validate_github_signature
    signature = "sha1=#{OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['GITHUB_SIGNATURE'], request.raw_post)}"
    Rack::Utils.secure_compare(signature, request.headers['X-Hub-Signature'])
  end
end
