class OrbitFeedbackNotifier
  def self.call(feedback)
    new(feedback).post!
  end

  def initialize(feedback)
    @feedback = feedback
  end

  def params
    @params ||= {
      email: @feedback.owner.email,
      resource: "Offered #{@feedback.sentiment} feedback on #{@feedback.resource.uri}",
    }
  end

  def orbit_uri
    URI("https://app.orbit.love/api/v1/#{ENV['ORBIT_WORKSPACE_ID']}/activities")
  end

  def post!
    http = Net::HTTP.new(orbit_uri.host, orbit_uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(orbit_uri.path, {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{ENV['ORBIT_API_KEY']}",
    })
    req.body = {
      'activity' => {
        title: 'Offered feedback on ADP',
        description: params[:resource],
        activity_type: 'adp:feedback',
        key: "adp-new-feedback-#{params[:email]}-#{Time.zone.now}",
      },
      'identity' => {
        'source' => 'ADP',
        'source_host' => 'https://developer.vonage.com',
        'email' => params[:email],
      },
    }
    req
  end
end
