class OrbitFeedbackNotifier
  CONFIG = YAML.load_file("#{Rails.configuration.docs_base_path}/config/business_info.yml")

  def self.call(feedback)
    new(feedback).post!
  end

  def initialize(feedback)
    @feedback = feedback
  end

  def params
    @params ||= {
      id: @feedback.id,
      email: @feedback.owner.email,
      resource: "Offered #{@feedback.sentiment} feedback on #{@feedback.resource.uri}",
    }
  end

  def uri
    @uri ||= URI("https://app.orbit.love/api/v1/#{ENV['ORBIT_WORKSPACE_ID']}/activities")
  end

  def post!
    return unless ENV['ORBIT_WORKSPACE_ID']

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri)
    req['Accept'] = 'application/json'
    req['Content-Type'] = 'application/json'
    req['Authorization'] = "Bearer #{ENV['ORBIT_API_KEY']}"

    req.body = {
      activity: {
        activity_type: 'adp:feedback',
        key: "adp-feedback-#{params[:id]}",
        title: 'Offered feedback on ADP',
        description: params[:resource],
        occurred_at: Time.zone.now.iso8601,
      },
      identity: {
        source: 'email',
        source_host: CONFIG['base_url'],
        email: params[:email],
      },
    }

    req.body = req.body.to_json

    http.request(req)
  end
end
