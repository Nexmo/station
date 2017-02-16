class CredentialsFilter < Banzai::Filter
  def call(input)
    # Remove frontmatter from the input
    # input.gsub!(/\$API_KEY/, current_user ? current_user.api_key : "API_KEY")
    # input.gsub!(/\$API_SECRET/, current_user ? current_user.api_secret : "API_SECRET")
    # input.gsub!(/\$TO_NUMBER/, current_user ? current_user.to_number : "TO_NUMBER")
    input
  end

  private

  def current_user
    # @current_user ||= OpenStruct.new({
    #   api_key: 'abc123',
    #   api_secret: 'abc123',
    #   to_number: '44123456789',
    # })
    nil
  end
end
