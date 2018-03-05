REDIRECTS = YAML.load_file("#{Rails.root}/config/redirects.yml")

class Redirector
  def self.find(request)
    find_by_config(request) || find_by_enviornment_redirect(request)
  end

  def self.find_by_config(request)
    REDIRECTS[request.path] || false
  end

  def self.find_by_enviornment_redirect(request)
    return false unless ENV['ENVIRONMENT_REDIRECTS']
    ENV['ENVIRONMENT_REDIRECTS'].each do |path, new_url|
      /#{Regexp.quote(path)}/ =~ request.path
      break new_url
    end
  end
end
