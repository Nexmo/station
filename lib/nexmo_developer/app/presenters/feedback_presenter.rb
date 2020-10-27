class FeedbackPresenter
  def initialize(canonical_url)
    @canonical_url = canonical_url
  end

  def props
    config.merge(
      'source' => @canonical_url,
      'configId' => feedback_config.id
    )
  end

  def config
    @config ||= YAML.safe_load(
      File.read("#{Rails.configuration.docs_base_path}/config/feedback.yml")
    )
  end

  def feedback_config
    @feedback_config ||= Feedback::Config.find_or_create_config(config)
  end
end
