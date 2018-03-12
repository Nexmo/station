class PartialFilter < Banzai::Filter
  def call(input)
    input.gsub(/```partial(.+?)```/m) do |_s|
      config = YAML.safe_load($1)
      content = File.read(config['source'])

      if config['platform']
        <<~HEREDOC
          <div class="js-platform" data-platform="#{config['platform']}">
            #{ content.render_markdown }
          </div>
        HEREDOC
      else
        content
      end
    end
  end
end
