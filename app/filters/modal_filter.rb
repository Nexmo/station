class ModalFilter < Banzai::Filter
  def call(input)
    modals = []

    input.gsub!(/@\[(.+?)\]\((.+?)\)/) do |s|
      uuid = SecureRandom.uuid
      modals << { document: $2, uuid: uuid }
      "<a data-open='#{uuid}'>#{$1}</a>"
    end

    modals = modals.map do |modal|
      document = File.read("#{Rails.root}/#{modal[:document]}")
      output = MarkdownPipeline.new.call(document)

      <<~HEREDOC
        <div class="reveal" id="#{modal[:uuid]}" data-reveal>
          #{output}
        </div>
      HEREDOC
    end

    input + modals.join("\n")
  end
end
