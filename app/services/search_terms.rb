class SearchTerms
  def self.generate
    document_paths = Dir.glob("#{Rails.root}/_documentation/**/*.md")

    document_paths.map do |document_path|
      document = File.read(document_path)
      frontmatter = YAML.load(document)
      title = frontmatter['title']
      description = frontmatter['description']

      origin = Pathname.new("#{Rails.root}/_documentation")
      document_path = Pathname.new(document_path)
      relative_path = "/#{document_path.relative_path_from(origin)}".gsub('.md', '')

      { title: title, description: description, path: relative_path, body: document }
    end
  end
end
