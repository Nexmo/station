REDIRECTS = YAML.load_file("#{Rails.root}/config/redirects.yml")

class Redirector
  def self.find(request)
    REDIRECTS[request.path] || false
  end
end
