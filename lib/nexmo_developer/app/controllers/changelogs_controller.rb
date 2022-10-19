class ChangelogsController < ApplicationController
  def index
    return if ENV['CHANGELOGS_PATH'].blank?

    @titles = Dir.glob("#{ENV['CHANGELOGS_PATH']}/**")
                 .select { |e| File.directory? e }
                 .map do |folder_path|
      {
        title: File.basename(folder_path),
        files: Dir.glob("#{folder_path}/*.md").map do |md_file|
          {
            file_title: File.basename(md_file, '.md'),
            frontmatter: File.read(md_file).match(/\A(---.+?---)/mo) ? YAML.safe_load(File.read(md_file)) : {},
          }
        end,
      }
    end
  end

  def show
    page_title  = helpers.sanitize(params[:name])
    folder_name = helpers.sanitize(params[:folder])

    if File.exist?("#{ENV['CHANGELOGS_PATH']}/#{folder_name}/#{page_title}.md")
      page = Dir.glob("#{ENV['CHANGELOGS_PATH']}/#{folder_name}/#{page_title}.md").first
      document = File.read(page).gsub(/\A(---.+?---)/mo, '')
    else
      document = "<h3>Sorry, this file doesn't exist!</h3><code><strong>/_changelogs/#{folder_name}/#{page_title}.md</strong></code>"
    end

    @content = Nexmo::Markdown::Renderer.new({}).call(document)
  end
end
