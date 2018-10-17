namespace :ci do
  desc 'Render all pages to make sure that no exceptions are thrown'
  task 'render_pages': :environment do
    document_paths =
      [
        "#{Rails.root}/_documentation/**/*.md",
        "#{Rails.root}/_api/**/*.md",
        "#{Rails.root}/_tutorials/**/*.md",
      ]
    document_paths.each do |path|
      Dir.glob(path).each do |filename|
        document = File.read(filename)
        MarkdownPipeline.new.call(document)
      end
    end
  end
end
