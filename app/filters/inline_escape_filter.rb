class InlineEscapeFilter < Banzai::Filter
  def call(input)
    # Freeze to prevent Markdown formatting
    input.gsub(/``(.+?)``/) do |s|
      frozen_code = Base64.urlsafe_encode64("<code>#{$1}</code>")
      Rails.logger.debug frozen_code
      "FREEZESTART#{frozen_code}FREEZEEND"
    end
  end
end
