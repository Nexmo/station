class SearchTerms
  def self.generate
    document_paths = Dir.glob("#{Rails.root}/_documentation/**/*.md")

    document_paths.map do |document_path|
      document = File.read(document_path)
      frontmatter = YAML.load(document)
      title = frontmatter["title"]

      { title: title, path: document_path, body: document }
    end
  end
end
